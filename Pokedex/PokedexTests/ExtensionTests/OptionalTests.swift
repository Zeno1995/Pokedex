//
//  OptionalTests.swift
//  PokedexTests
//
//  Created by Enzo Corsiero on 29/11/21.
//

import XCTest
@testable import Pokedex

class OptionalTests: XCTestCase {

    func testString() throws {
        let string: String? = nil
        XCTAssertNotNil(string.stringOrEmpty)
        
        let valueString: String? = "Pippo"
        XCTAssertEqual(valueString.stringOrEmpty, "Pippo")
    }

    func testBool() throws {
        let string: Bool? = nil
        XCTAssertNotNil(string.boolOrFalse)
        
        let valueBool: Bool? = true
        XCTAssertEqual(valueBool.boolOrFalse, true)
    }
}
