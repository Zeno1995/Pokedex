//
//  OperationPromise.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

protocol Chainable: class {
    associatedtype In
    associatedtype Out
    associatedtype Err: OperationError

    var onCancel: (() -> Void)? { get set }
    var onSuccess: ((Out) -> Void)? { get set }
    var onError: ((Err) -> Void)? { get set }
    var onCompletion: Completion<Out, Err>? { get set }

    init(input: In, container: Container, useStub: Bool?, noCache: Bool?)
}

final class OperationPromise<O: Chainable> {
    typealias Callback = (Result<O.Out, O.Err>) -> Void

    private let type: O.Type

    private let container: Container
    private let useStub: Bool
    private let noCache: Bool
    private let queue: OperationQueue
    private var callbacks = [Callback]()

    private var onError: ((O.Err) -> Void)?
    private var onSuccess: ((O.Out) -> Void)?
    private var onCatchAll: ((Swift.Error) -> Void)?
    private var onCancel: (() -> Void)?

    private var result: Result<O.Out, O.Err>?
    private var previousError: Swift.Error?

    init(type: O.Type, container: Container, useStub: Bool? = false, noCache: Bool? = false, queue: OperationQueue) {
        self.type = type
        self.queue = queue
        self.container = container

        #if DEBUG
            self.useStub = useStub.boolOrFalse
        #else
            self.useStub = false
        #endif

        self.noCache = noCache.boolOrFalse
    }

    deinit {

    }

    private func handlerError(_ error: Swift.Error?) {
        guard let localError = error else { return }
        onCatchAll?(localError)
        callbacks.forEach { callback in
            let callbackError = O.Err.map(error: localError)
            callback(.failure(callbackError))
        }
    }

    private func handleResult() {
        guard let operationResult = result else { return }
        self.callbacks.forEach { $0(operationResult) }

        switch operationResult {
        case let .success(value):
            onSuccess?(value)
        case let .failure(error):
            onError?(error)
            onCatchAll?(error)
        }
    }
}

// MARK: - Chaining functions
extension OperationPromise {
    @discardableResult
    func start(input: O.In, stubFlag: Bool? = false, noCache: Bool? = false) -> O {

        #if DEBUG
            let flag = stubFlag.boolOrFalse
        #else
            let flag = false
        #endif

        let flagResetCache = noCache.boolOrFalse

        let op = O(input: input, container: container, useStub: flag, noCache: flagResetCache)

        op.onCompletion = { [weak self] result in
            self?.result = result
            self?.handleResult()
        }
        op.onCancel = { [weak self] in
            self?.onCancel?()
            self?.callbacks.forEach { $0(.failure(O.Err.cancel())) }
        }

        if let operation = op as? Operation {
            queue.addOperation(operation)
        }

        return op
    }

    @discardableResult
    func then<T: Chainable>(_ thenType: T.Type, stubFlag: Bool? = false, noCache: Bool? = false) -> OperationPromise<T> where T.In == O.Out {

        #if DEBUG
            let flag = stubFlag.boolOrFalse
        #else
            let flag = false
        #endif

        let flagResetCache = noCache.boolOrFalse

        let promise = OperationPromise<T>(type: thenType,
                                          container: container,
                                          useStub: flag,
                                          noCache: flagResetCache,
                                          queue: queue)

        let callback: Callback = { result in
            if let output = result.value {
                promise.start(input: output, stubFlag: flag, noCache: flagResetCache)
            }

            if let error = result.error {
                promise.previousError = error
                promise.handlerError(error)
            }
        }

        callbacks.append(callback)

        if let operationResult = result {
            callback(operationResult)
        }

        return promise
    }

    @discardableResult
    func then<Out>(stubFlag: Bool? = false, noCache: Bool? = false, _ block: @escaping (O.Out) throws -> Out) -> OperationPromise<ActionOperation<O.Out, Out, O.Err>> {

        #if DEBUG
            let flag = stubFlag.boolOrFalse
        #else
            let flag = false
        #endif

        let flagResetCache = noCache.boolOrFalse

        let promise = OperationPromise<ActionOperation<O.Out, Out, O.Err>>(type: ActionOperation<O.Out, Out, O.Err>.self,                                                                   container: container,
                                                                           useStub: flag,
                                                                           noCache: flagResetCache,
                                                                           queue: queue)

        let callback: Callback = { result in
            if let output = result.value {
                promise.start(input: Action(input: output, action: block), stubFlag: flag, noCache: flagResetCache)
            }

            if let error = result.error {
                promise.previousError = error
                promise.handlerError(error)
            }
        }

        callbacks.append(callback)

        if let operationResult = result {
            callback(operationResult)
        }

        return promise
    }

    @discardableResult
    func thenOnError<T: Chainable>(_ thenType: T.Type, stubFlag: Bool? = false, noCache: Bool? = false) -> OperationPromise<T> where T.In == O.Err {

        #if DEBUG
            let flag = stubFlag.boolOrFalse
        #else
            let flag = false
        #endif

        let flagResetCache = noCache.boolOrFalse

        let promise = OperationPromise<T>(type: thenType,
                                          container: container,
                                          useStub: flag,
                                          noCache: flagResetCache,
                                          queue: queue)

        let callback: Callback = { result in
            guard let error = result.error else { return }
            promise.start(input: error, stubFlag: flag, noCache: flagResetCache)
        }

        callbacks.append(callback)

        if let operationResult = result {
            callback(operationResult)
        }

        return promise
    }
}

// MARK: - Handlers
extension OperationPromise {
    @discardableResult
    func canceled(_ body: @escaping () -> Void) -> Self {
        onCancel = body
        return self
    }

    @discardableResult
    func success(_ body: @escaping (O.Out) -> Void) -> Self {
        onSuccess = body
        return self
    }

    @discardableResult
    func error(_ body: @escaping (O.Err) -> Void) -> Self {
        onError = body
        handlerError(previousError)
        return self
    }

    @discardableResult
    func catchAll(_ body: @escaping (Swift.Error) -> Void) -> Self {
        onCatchAll = body
        handlerError(previousError)
        return self
    }
}

struct Action<In, Out> {
    let input: In
    let action: (In) throws -> Out
}

final class ActionOperation<I, O, E: OperationError>: StandardOperation<Action<I, O>, O, E> {
    override func perform() throws {
        let output = try input.action(input.input)
        finish(output: output)
    }
}
