//
//  Result.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

struct StateProgress {
    let progress: Float
    let message: String
    
    init(progress: Float, message: String = String.empty) {
        self.progress = progress
        self.message = message
    }
}

struct Callback<T, E: Swift.Error> {
    typealias State = (StateProgress) -> Void
    let completion: Completion<T, E>
    let state: State?
    
    init(completion: @escaping Completion<T, E>) {
        self.completion = completion
        self.state = nil
    }
    
    init(completion: @escaping Completion<T, E>, state: @escaping State) {
        self.completion = completion
        self.state = state
    }
    
    init(completion: @escaping Completion<T, E>, progress: @escaping (Float) -> Void) {
        self.completion = completion
        self.state = { state in
            progress(state.progress)
        }
    }
}

// A generic completion handler type.
typealias Completion<T, E: Swift.Error> = (Result<T, E>) -> Void

// A generic progress handler
typealias ProgressHandler = (Float) -> Void

// Defines a generic Result type.
// - success: success type.
// - failure: failure type.
enum Result<T, E: Swift.Error> {
    case success(T)
    case failure(E)
}

extension Result {
    var isSuccessful: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}

extension Result {
    func analysis<Result>(ifSuccess: (T) -> Result, ifFailure: (E) -> Result) -> Result {
        switch self {
        case let .success(value):
            return ifSuccess(value)
        case let .failure(value):
            return ifFailure(value)
        }
    }
    
    func dematerialize() throws -> T {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}

extension Result {
    var value: T? {
        return analysis(ifSuccess: { $0 }, ifFailure: { _ in nil })
    }
    
    var error: E? {
        return analysis(ifSuccess: { _ in nil }, ifFailure: { $0 })
    }
    
    func map<U>(_ transform: (T) -> U) -> Result<U, E> {
        return flatMap { .success(transform($0)) }
    }
    
    func flatMap<U>(_ transform: (T) -> Result<U, E>) -> Result<U, E> {
        return analysis(ifSuccess: transform, ifFailure: Result<U, E>.failure)
    }
}
