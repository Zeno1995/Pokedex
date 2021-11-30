//
//  NetworkCacheTests.swift
//  PokedexTests
//
//  Created by Enzo Corsiero on 29/11/21.
//

import XCTest
@testable import Pokedex

class NetworkCacheTests: XCTestCase {

    private lazy var cache: NetworkCache = NetworkCache()

    let jsonTest = """
    {
        "field1": "String",
        "field2": true,
        "field3: 1
    }
    """

    let key = "key"
    let ttl: UInt = 2 // 2 sec

    func testTTLExapiredCache() throws {
        let data = jsonTest.data(using: .utf8)!
        cache.setObject(data, forKey: key, withTTL: ttl)
        sleep(3)
        XCTAssert(cache.object(forKey: key) == nil)
    }

    func testTTLValidCache() throws {
        let data = jsonTest.data(using: .utf8)!
        cache.setObject(data, forKey: key, withTTL: ttl)
        sleep(1)
        if let object = cache.object(forKey: key) {
            XCTAssert(data == object)
        }
    }

}
