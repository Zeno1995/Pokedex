//
//  StandardOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

protocol ErrorTraceable {
    func registerErrorTrace(_ key: String, name: String)
}

protocol OperationError: Swift.Error {
    static func cancel() -> Self
    static func map(error: Swift.Error) -> Self
}

enum StandardOperationError: OperationError {
    case canceled
    case generic(Swift.Error)

    static func cancel() -> StandardOperationError {
        return .canceled
    }

    static func map(error: Swift.Error) -> StandardOperationError {
        if let standardError = error as? StandardOperationError {
            return standardError
        }

        return .generic(error)
    }
}

typealias StandardCompletion<Out, Err: OperationError> = Completion<Out, Err>

class StandardOperation<Input, Output, Failure: OperationError>: BaseOperation, Chainable {
    
    typealias In = Input
    typealias Out = Output
    typealias Err = Failure

    var onError: ((Failure) -> Void)?
    var onSuccess: ((Output) -> Void)?
    var onCompletion: StandardCompletion<Output, Failure>?
    var onCancel: (() -> Void)?
    var onProgress: ProgressHandler?

    let input: Input
    let container: Container
    let useStub: Bool
    let noCache: Bool

    private var promise: AnyObject?

    required init(input: Input, container: Container, useStub: Bool? = false, noCache: Bool? = false) {
        self.input = input
        self.container = container

        #if DEBUG
            self.useStub = useStub.boolOrFalse
        #else
            self.useStub = false
        #endif

        self.noCache = noCache.boolOrFalse
    }

    convenience init(input: Input, container: Container, useStub: Bool? = false, noCache: Bool? = false, onProgress: @escaping ProgressHandler) {
        self.init(input: input, container: container, useStub: useStub, noCache: noCache)
        self.onProgress = onProgress
    }

    open func perform() throws { }

    override func finish() {
        assertionFailure("Called the wrong finish. Please use finish(output: \(type(of: Output.self))")
    }

    override final func execute() {
        do {
            try perform()
        } catch let error as Failure {
            finish(error: error)
        } catch {
            finish(error: Failure.map(error: error))
        }
    }

    override open func cancel() {
        super.cancel()

        if let action = onCancel {
            action()
        }
    }
}

extension StandardOperation {
    @discardableResult
    func begin<T>(with type: T.Type, input: T.In, stubFlag: Bool? = false, noCache: Bool? = false) -> OperationPromise<T> {

        #if DEBUG
            let flag = stubFlag.boolOrFalse
        #else
            let flag = false
        #endif

        let flagResetCache = noCache.boolOrFalse

        let operationPromise = OperationPromise<T>(type: type,
                                                   container: container,
                                                   useStub: flag,
                                                   noCache: flagResetCache,
                                                   queue: internalQueue)

        promise = operationPromise
        operationPromise.start(input: input, stubFlag: flag, noCache: flagResetCache)
        return operationPromise
    }

    @discardableResult
    func begin<T>(with type: T.Type, stubFlag: Bool? = false, noCache: Bool? = false) -> OperationPromise<T> where T.In == Void {

        #if DEBUG
            let flag = stubFlag.boolOrFalse
        #else
            let flag = false
        #endif

        let flagResetCache = noCache.boolOrFalse

        let operationPromise = OperationPromise<T>(type: type,
                                                   container: container,
                                                   useStub: flag,
                                                   noCache: flagResetCache,
                                                   queue: internalQueue)

        promise = operationPromise
        operationPromise.start(input: Void(), stubFlag: flag, noCache: flagResetCache)
        return operationPromise
    }
}

extension StandardOperation {
    func finish(output: Output) {
        super.finish()

        if let action = onSuccess {
            action(output)
        }

        if let completion = onCompletion {
            completion(.success(output))
        }
    }

    func finish(error: Failure) {
        super.finish()
        if let action = onError {
            action(error)
        }

        if let completion = onCompletion {
            completion(.failure(error))
        }
    }
}

extension StandardOperation where Input == Void {
    convenience init(container: Container, useStub: Bool? = false, noCache: Bool? = false) {

        #if DEBUG
            let flag = useStub.boolOrFalse
        #else
            let flag = false
        #endif

        let flagResetCache = noCache.boolOrFalse

        self.init(input: Void(), container: container, useStub: flag, noCache: flagResetCache)
    }
}

extension StandardOperation {
    func cache() -> NetworkCache? {
        do {
            let sessionService: SessionService = try container.resolve()
            return sessionService.networkCache()
        } catch {
            return nil
        }
    }
    
    func stubEnvironment() -> Environment? {
        #if DEBUG
            let stubEnv: Environment = {
                var header = EnvironmentHeaders()
                header["Content-Type"] = "application/json"
                header["Accept"] = "application/json"
                return Environment(name: "stub", host: "http://127.0.0.1:8000/stub", headers: header)
            }()
            return stubEnv
        #else
            return nil
        #endif
    }
}

