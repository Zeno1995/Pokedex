//
//  Network.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

typealias NetworkCompletion = Completion<NetworkResponse, NetworkError>

enum NetworkError: OperationError {
    case invalidData
    case invalidStatusCode(code: Int)
    case invalidUrl(url: String)
    case networkError(Swift.Error)
    case notConnectedToInternet
    case generic(Swift.Error)
    case canceled
    
    static func cancel() -> NetworkError {
        return .canceled
    }
    
    static func map(error: Error) -> NetworkError {
        if let netError = error as? NetworkError {
            return netError
        }
        
        return .generic(error)
    }
}

protocol Network: Service {
    func perform(request: NetworkRequest, completion: @escaping NetworkCompletion) -> Operation
}
