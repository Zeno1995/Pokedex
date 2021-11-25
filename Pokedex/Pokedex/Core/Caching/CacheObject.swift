//
//  CacheObject.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

class CacheObject {
    var data : Any
    var expirationDate : Date
    
    init(data: Any, ttl: UInt) {
        self.data = data
        expirationDate = CacheObject.expirationDate(fromTTL: ttl)
    }
    
    func expired() -> Bool {
        return expirationDate.timeIntervalSinceNow < 0
    }
    
    func setTTL(_ ttl: UInt) {
        expirationDate = CacheObject.expirationDate(fromTTL: ttl)
    }
    
    class func expirationDate(fromTTL ttl: UInt) -> Date {
        return ttl == 0 ? Date.distantFuture : Date() + TimeInterval(ttl)
    }
}
