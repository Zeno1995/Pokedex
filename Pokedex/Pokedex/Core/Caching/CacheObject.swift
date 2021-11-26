//
//  CacheObject.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

class CacheObject: Codable {
    private var data: Data
    var expirationDate: TimeInterval

    init(data: Data, ttl: UInt) throws {
        self.data = data
        expirationDate = CacheObject.expirationDate(fromTTL: ttl)
    }

    func expired() -> Bool {
        expirationDate - Date().timeIntervalSince1970 < 0
    }

    func setTTL(_ ttl: UInt) {
        expirationDate = CacheObject.expirationDate(fromTTL: ttl)
    }

    func getData() throws -> Data {
        return data
    }

    class func expirationDate(fromTTL ttl: UInt) -> TimeInterval {
        ttl == 0 ? Date.distantFuture.timeIntervalSince1970 : (Date() + TimeInterval(ttl)).timeIntervalSince1970
    }
}
