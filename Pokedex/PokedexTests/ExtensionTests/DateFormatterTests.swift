//
//  DateFormatterTests.swift
//  PokedexTests
//
//  Created by Enzo Corsiero on 29/11/21.
//

import XCTest
@testable import Pokedex

class DateFormatterTests: XCTestCase {
    
    func testIso8601Full() throws {
        XCTAssertNotNil(DateFormatter.iso8601Full.date(from: "2017-11-16T02:02:55.000-08:00"))
        XCTAssertNotNil(DateFormatter.iso8601Full.date(from: "2023-11-25T02:02:55.000-12:32"))
        XCTAssertNil(DateFormatter.iso8601Full.date(from: "2017-11-33T02:02:55.000-08:00"))
        XCTAssertNil(DateFormatter.iso8601Full.date(from: "2017-11-16"))
    }
}
