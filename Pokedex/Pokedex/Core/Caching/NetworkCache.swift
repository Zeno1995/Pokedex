//
//  NetworkCache.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import Dispatch

class NetworkCache {
    
    private var cache = [AnyHashable : CacheObject]()
    private let defaultTTL: UInt
    private let checkFrequency: UInt
    
    private(set) var statistics: Statistics

    private var timer: DispatchSourceTimer?
    private let timerQueue: DispatchQueue
    private let queue: DispatchQueue
    
    init(defaultTTL: UInt = 0, checkFrequency: UInt = 60) {
        self.defaultTTL = defaultTTL
        self.checkFrequency = checkFrequency
        statistics = Statistics()
        queue =  DispatchQueue(label: "NetworkCache: queue", attributes: .concurrent)
        timerQueue =  DispatchQueue(label: "NetworkCache: timerQueue")
        startDataChecks()
    }
    
    deinit {
        stopDataChecks()
    }
    
    private func setCacheObject<T: Hashable>(_ object: Any, forKey key: T, withTTL ttl: UInt) {
        if let cacheObject = cache[AnyHashable(key)] {
            cacheObject.data = object
            cacheObject.setTTL(ttl)
        }
        else {
            cache[AnyHashable(key)] = CacheObject(data: object, ttl: ttl)
            statistics.numberOfKeys += 1
        }
    }
    
    func setObject<T: Hashable>(_ object: Any, forKey key: T, withTTL: UInt?=nil) {
        let ttl = withTTL ?? defaultTTL
        queue.sync(flags: [.barrier]) { setCacheObject(object, forKey: key, withTTL: ttl) }
    }
    
    private func getCacheObject<T: Hashable>(forKey key: T) -> Any? {
        if let cacheObject = cache[AnyHashable(key)], !cacheObject.expired() {
            statistics.hits += 1
            return cacheObject.data
        }
        else {
            statistics.misses += 1
            return nil
        }
    }
    
    func object<T: Hashable>(forKey key: T) -> Any? {
        var object : Any?
        queue.sync() { object = getCacheObject(forKey: key) }
        return object
    }
    
    func keys() -> [Any] {
        var keys : [Any]?
        queue.sync() { keys = cacheKeys() }
        return keys!
    }
    
    private func cacheKeys() -> [Any] {
        var keys = [Any]()
        for key in self.cache.keys {
            keys.append(key.base)
        }
        return keys
    }
    
    func removeObject<T: Hashable>(forKey key: T) {
        removeObjects(forKeys: [key])
    }
    
    func removeObjects<T: Hashable>(forKeys keys: T...) {
        removeObjects(forKeys: keys)
    }
    
    func removeObjects<T: Hashable>(forKeys keys: [T]) {
        queue.sync(flags: [.barrier]) {
            removeCacheObjects(forKeys: keys)
        }
    }

    private func removeCacheObjects<T: Hashable>(forKeys keys: [T]) {
        for key in keys {
            if let _ = cache.removeValue(forKey: AnyHashable(key)) {
                statistics.numberOfKeys -= 1
            }
        }
    }
    
    func removeAllObjects() {
        queue.sync(flags: [.barrier]) { removeAllCacheObjects() }
    }
    
    private func removeAllCacheObjects() {
        self.cache.removeAll()
        self.statistics.numberOfKeys = 0
    }
    
    func setTTL<T: Hashable>(_ ttl: UInt, forKey key: T) -> Bool {
        var success = false
        queue.sync(flags: [.barrier]) { success = setCacheObjectTTL(ttl, forKey: key) }
        return success
    }
    
    private func setCacheObjectTTL<T: Hashable>(_ ttl: UInt, forKey key: T) -> Bool {
        if let cacheObject = cache[AnyHashable(key)], !cacheObject.expired() {
            cacheObject.setTTL(ttl)
            return true
        }
        return false
    }
    
    func flush() {
        queue.sync(flags: [.barrier]) { flushCache() }
    }
    
    private func flushCache() {
        cache.removeAll()
        statistics.reset()
    }
    
    
    private func check() {
        for (key, cacheObject) in cache {
            if cacheObject.expired() {
                if let _ = cache.removeValue(forKey: key) {
                    statistics.numberOfKeys -= 1
                }
            }
        }
    }
    
    private func startDataChecks() {
        timer = DispatchSource.makeTimerSource(queue: timerQueue)
        timer!.schedule(deadline: DispatchTime.now(), repeating: Double(checkFrequency), leeway: DispatchTimeInterval.milliseconds(1))
        timer!.setEventHandler() { self.queue.async(flags: [.barrier], execute: self.check) }
        timer!.resume()
    }
    
    private func restartDataChecks() {
        guard let timer = timer else { return }
        timer.suspend()
        timer.schedule(deadline: DispatchTime.now(), repeating: Double(checkFrequency))
        timer.resume()
    }
    
    private func stopDataChecks() {
        guard let _ = timer else { return }
        timer!.cancel()
        timer = nil
    }
}
