//
//  NetworkResponse.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

// Defines the possible origin of the body,
// - fromNetwork: The body originates from the network.
// - fromCache: The body originates from a local cache
enum BodyOrigin {
    case fromNetwork
    case fromCache
}

struct NetworkResponse {
    
    // The response body
    let body: Data
    
    // The body origin
    let bodyOrigin: BodyOrigin
    
    // The network request
    let request: NetworkRequest
    
    // The http url response
    let httpUrlResponse: HTTPURLResponse
    
    // HTTP headers
    var headers: [AnyHashable: Any] {
        return self.httpUrlResponse.allHeaderFields
    }
    
    // HTTP status code
    var statusCode: Int {
        return self.httpUrlResponse.statusCode
    }
    
    // Initialize a complete new network response.
    // - Parameters:
    //   - body: The http body response.
    //   - httpUrlResponse: The http url response.
    //   - body: Response body.
    //   - bodyOrigin: Response body origin.
    init(request: NetworkRequest, httpUrlResponse: HTTPURLResponse, body: Data, bodyOrigin: BodyOrigin = .fromNetwork) {
        self.request = request
        self.httpUrlResponse = httpUrlResponse
        self.body = body
        self.bodyOrigin = bodyOrigin
    }
    
    init(request: NetworkRequest, urlRequest: URL, body: Data, bodyOrigin: BodyOrigin = .fromNetwork) {
        self.request = request
        self.httpUrlResponse = HTTPURLResponse(url: urlRequest, statusCode: 200, httpVersion: nil, headerFields: nil)!
        self.body = body
        self.bodyOrigin = bodyOrigin
    }
}
