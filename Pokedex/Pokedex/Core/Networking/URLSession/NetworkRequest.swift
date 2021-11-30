//
//  NetworkRequest.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

enum NetworkRequestError: Swift.Error {
    case invalidUrl
    case noEnvironmentProvided
}

// MARK: - Nested types
extension NetworkRequest {
    
    enum HTTPMethod: String, Codable {
        case post = "POST"
        case put = "PUT"
        case get = "GET"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    enum CachePolicy: UInt, Codable {
        case doNotCache
        case useLocalWhenRemoteError
    }
    
    enum AuthPolicy: UInt, Codable {
        case none
        case basic
        case oauth2
        case jwt
    }
}

// Defines a generic network request.
struct NetworkRequest {
    // The HTTP method used to perform the request.
    let method: HTTPMethod
    
    // Relative path of the endpoint we want to call (ie. `/users/login`)
    let path: String
    
    // The list of http headers to pass along with request.
    var headers = [String: String]()
    
    // The list of key-value param to pass in query string (i.e. '?key=val').
    var queryParams = [String: String]()
    
    // The request body.
    var body: Foundation.Data?
    
    // The local cache.
    let localCache: NetworkCache?
    
    // The local key cache.
    let localCacheKey: String?
    
    // Time to leave.
    let ttlRequest: UInt?
    
    private(set) var environment: Environment?
    
    init(method: HTTPMethod = .get,
                path: String,
                headers: [String: String] = [:],
                queryParams: [String: String] = [:],
                body: Foundation.Data? = nil,
                localCache: NetworkCache? = nil,
                localCacheKey: String? = nil,
                ttlRequest: UInt? = nil) {
        
        self.method = method
        self.path = path
        self.headers = headers
        self.queryParams = queryParams
        self.body = body
        self.localCache = localCache
        self.localCacheKey = localCacheKey
        self.ttlRequest = ttlRequest
    }
    
    init<T: Encodable>(method: HTTPMethod = .get,
                              path: String,
                              headers: [String: String] = [:],
                              queryParams: [String: String] = [:],
                              bodyValue: T,
                              localCache: NetworkCache? = nil,
                              localCacheKey: String? = nil,
                              ttlRequest: UInt? = nil) throws {
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        let bodyData = try encoder.encode(bodyValue)
        self.init(method: method, path: path, headers: headers, queryParams: queryParams, body: bodyData, localCache: localCache, localCacheKey: localCacheKey, ttlRequest: ttlRequest)
    }
}

// MARK: - Builder
extension NetworkRequest {
    // Update the request environment. It can be used a single time to update a request, before it fallback to the default one (during URLSessionOperation).
    // - Parameter env: The environment to use for the request
    mutating func update(environment env: Environment) {
        if environment == nil {
            self.environment = env
        }
    }
}

// MARK: - Builder
extension NetworkRequest {
    func buildURLRequest() throws -> URLRequest {
        
        guard let env = environment else {
            throw NetworkRequestError.noEnvironmentProvided
        }
        
        guard var urlComponents = URLComponents(string: "\(env.host)\(path)") else {
            throw NetworkRequestError.invalidUrl
        }
        
        // Add query items.
        if !queryParams.isEmpty {
            let items = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponents.queryItems = urlComponents.queryItems == nil ? [] : urlComponents.queryItems
            urlComponents.queryItems?.append(contentsOf: items)
        }
        
        guard let url = urlComponents.url else {
            throw NetworkRequestError.invalidUrl
        }
        
        // Build a new URLRequest.
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: getTimeoutInterval(path: path))
        urlRequest.httpBody = body
        urlRequest.httpMethod = method.rawValue
        env.headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        return urlRequest
    }
    
    func getUrl() -> URL? {
        do {
            let urlRequest:URLRequest = try self.buildURLRequest()
            guard let url:URL = urlRequest.url else { return nil }
            return url
        } catch {
            return nil
        }
    }
    
}

extension NetworkRequest {
    private func getTimeoutInterval(path: String) -> Double {
        return 30
    }
}
