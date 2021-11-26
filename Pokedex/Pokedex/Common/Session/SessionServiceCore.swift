//
//  SessionServiceCore.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

class SessionServiceCore: BaseService, SessionService {
    
    private lazy var cache: NetworkCache = NetworkCache()
}

extension SessionServiceCore {
    func networkCache() -> NetworkCache {
        return cache
    }
}
