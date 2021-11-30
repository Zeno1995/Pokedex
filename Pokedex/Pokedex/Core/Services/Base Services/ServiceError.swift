//
//  ServiceError.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

enum ServiceError: OperationError {
    case canceled
    case generic(Swift.Error)
    case network(Swift.Error)
    case unauthorized
    case invalidServerResponse

    
    static func cancel() -> ServiceError {
        return .canceled
    }
    
    static func map(error: Error) -> ServiceError {
        
        if let localError = error as? ServiceError {
            return localError
        }
        
        if (error as? DecodingError) != nil {
            return .invalidServerResponse
        }
        
        return .generic(error)
    }
    
    var localizedDescription: String {
        switch self {
        case .generic(let error):
            return error.localizedDescription
        case .network(let error):
            return error.localizedDescription
        default:
            return Localizer.Alert.genericError.localized
        }
    }
}

protocol Service {
}
