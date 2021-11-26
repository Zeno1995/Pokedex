//
//  SessionServiceCore.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

class SessionServiceCore: BaseService, SessionService {
    
    private lazy var cache: NetworkCache = NetworkCache()
    private lazy var imgCache: ImageCache = ImageCache()
}

extension SessionServiceCore {
    func networkCache() -> NetworkCache {
        return cache
    }
    
    func imageCache() -> ImageCache {
        imgCache
    }
}
