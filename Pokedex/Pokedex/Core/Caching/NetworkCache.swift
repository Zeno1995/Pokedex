//
//  NetworkCache.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import Dispatch

class NetworkCache {

    private let defaultTTL: UInt
    private let queue: DispatchQueue

    init(defaultTTL: UInt = 0, checkFrequency: UInt = 60) {
        self.defaultTTL = defaultTTL
        queue = DispatchQueue(label: "NetworkCache: queue", attributes: .concurrent)
        self.clearExpired()
    }

    private func setCacheObject(_ object: Data, forKey key: String, withTTL ttl: UInt) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)

        do {
            let cacheObject = try CacheObject(data: object, ttl: ttl)
            let cacheData = try encoder.encode(cacheObject)
            try cacheData.write(to: self.buildFilePath(key: key))
        } catch {}
    }

    func setObject(_ object: Data, forKey key: String, withTTL: UInt?=nil) {
        let ttl = withTTL ?? defaultTTL
        queue.sync(flags: [.barrier]) { [weak self] in
            guard let self = self else { return }
            self.setCacheObject(object, forKey: key, withTTL: ttl)
        }
    }

    private func getCacheObject(forKey key: String) -> Data? {
        do {
            let object = try self.getObject(url: self.buildFilePath(key: key))
            return try object.getData()
        } catch {
            return nil
        }
    }

    @discardableResult
    private func getObject(url: URL) throws -> CacheObject {
        do {
            let savedData = try Data(contentsOf: url)
            let cacheObject = try JSONDecoder().decode(CacheObject.self, from: savedData)
            if cacheObject.expired() {
                try FileManager.default.removeItem(at: url)
                #if DEBUG
                print("\n\n\n🔥🔥🔥🔥🔥🔥🔥🔥🔥\n💊 CACHE: \nAUTO REMOVED: \(url.lastPathComponent)\n\n\n")
                #endif
                throw CacheError.expired
            }
            return cacheObject
        } catch {
            throw CacheError.nofFound
        }
    }

    func object(forKey key: String) -> Data? {
        var object: Data?
        queue.sync { [weak self] in
            guard let self = self else { return }
            object = self.getCacheObject(forKey: key)
        }
        return object
    }

    func removeObject(forKey key: String) {
        removeObjects(forKeys: [key])
    }

    func removeObjects(forKeys keys: [String]) {
        queue.sync(flags: [.barrier]) { [weak self] in
            guard let self = self else { return }
            self.removeCacheObjects(forKeys: keys)
        }
    }

    private func removeCacheObjects(forKeys keys: [String]) {
        for key in keys {
            do {
                try FileManager.default.removeItem(at: self.buildFilePath(key: key))
                #if DEBUG
                print("\n\n\n🔥🔥🔥🔥🔥🔥🔥🔥🔥\n💊 CACHE: \nREMOVED: \(key)\n\n\n")
                #endif
            } catch {
                continue
            }
        }
    }

    public func removeAllCacheObjects() {
        do {
            try FileManager.default.removeItem(at: self.buildFolder())
        } catch { }
    }

    private func clearExpired() {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: self.buildFolder(),
                                                                                includingPropertiesForKeys: nil,
                                                                                options: [])
            for url in directoryContents {
                do {
                    try self.getObject(url: url)
                } catch {
                    continue
                }
            }
        } catch {}
    }

    private func buildFilePath(key: String) throws -> URL {
        let key = key.replacingOccurrences(of: "/", with: "")
        var documentDirectoryURL = try self.buildFolder()
        try FileManager.default.createDirectory(at: documentDirectoryURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
        documentDirectoryURL.appendPathComponent(key)
        return documentDirectoryURL
    }

    private func buildFolder() throws -> URL {
        var documentDirectoryURL = try FileManager.default.url(for: .cachesDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil,
                                                               create: false)
        documentDirectoryURL.appendPathComponent("caching")
        return documentDirectoryURL
    }
}
