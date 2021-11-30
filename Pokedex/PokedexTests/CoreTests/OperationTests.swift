//
//  OperationTests.swift
//  PokedexTests
//
//  Created by Enzo Corsiero on 29/11/21.
//

import XCTest
@testable import Pokedex

class OperationTests: XCTestCase {

    let container: Container = ComponentContainer()

    var core: Core!

    override func setUp() {
        super.setUp()
        self.core = Core(container: container, environment: .mainEnviroment)
    }

    func testMappingOperation() throws {
        struct ResponseTest: Decodable {
            let testo: String
            let numero: Int
            let booleano: Bool
            let oggetto: ResponseObject

            struct ResponseObject: Decodable {
                let testo: String
                let float: CGFloat
            }
        }

        var request = NetworkRequest(path: "")
        request.update(environment: .mainEnviroment)
        let networkResponse = """
            {
                "testo": "text",
                "numero": 1,
                "booleano": true,
                "oggetto": {
                            "testo": "text",
                            "float": 2.99
                            }
            }
        """
        let responseData = networkResponse.data(using: .utf8)!
        let response = NetworkResponse(request: request,
                                       httpUrlResponse: HTTPURLResponse(url: request.getUrl()!,
                                                                        statusCode: 200,
                                                                        httpVersion: nil,
                                                                        headerFields: nil)!,
                                       body: responseData,
                                       bodyOrigin: .fromCache)
        let op = MappingOperation<ResponseTest>(input: response, container: container)
            op.onSuccess = { output in
                XCTAssertEqual(output.testo, "text")
                XCTAssertEqual(output.numero, 1)
                XCTAssertEqual(output.booleano, true)
                XCTAssertEqual(output.oggetto.testo, "text")
                XCTAssertEqual(output.oggetto.float, 2.99)
            }
        try op.perform()

    }

}
