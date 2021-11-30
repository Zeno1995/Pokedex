//
//  StringTests.swift
//  PokedexTests
//
//  Created by Enzo Corsiero on 29/11/21.
//

import XCTest
@testable import Pokedex

class StringTests: XCTestCase {
    
    func testEmptyString() throws {
        XCTAssertEqual(String.empty, "")
        XCTAssertNotEqual(String.empty, " ")
    }
}
