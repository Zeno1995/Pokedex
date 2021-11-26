//
//  CacheError.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

enum CacheError: Swift.Error {
    case nofFound
    case expired
    case folderNotFound
}
