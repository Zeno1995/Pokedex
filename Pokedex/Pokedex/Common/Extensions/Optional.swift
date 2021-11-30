//
//  Optional.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

extension Optional where Wrapped == String {
    var stringOrEmpty: String {
        switch self {
        case .none:
            return String.empty
        case .some(let value):
            return value
        }
    }
}

extension Optional where Wrapped == Bool {
    var boolOrFalse: Bool {
        switch self {
        case .none:
            return false
        case .some(let value):
            return value
        }
    }
}
