//
//  URLSessionOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

struct URLSessionOperationInput {
    let request: NetworkRequest
    let environment: Environment
    let configuration: URLSessionConfiguration
}

final class URLSessionOperation: StandardOperation<URLSessionOperationInput, NetworkResponse, NetworkError>, URLSessionDataDelegate {
    fileprivate lazy var session = URLSession(configuration: input.configuration, delegate: self, delegateQueue: nil)
    private weak var task: URLSessionTask?
    
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    override func perform() throws {
        
        // Vars
        var request = input.request
        request.update(environment: input.environment)
        
        // Operation name
        self.name = "\(request.method.rawValue) \(request.path)"
        
        // Create a new URLRequest from NetworkRequest
        let urlRequest = try request.buildURLRequest()

        if let cache = request.localCache, let key = request.localCacheKey, let _ = input.request.ttlRequest, key.isEmpty == false {
            if let item = cache.object(forKey: key) {
                let body:Data = item as! Data
                #if DEBUG
                print("\n\n\n\n\n\n🔥🔥🔥🔥🔥🔥🔥🔥🔥\n💊 CACHE:\n\(String(describing: self.name))\nLOAD key:\(key)  ->  \(body)\n\n\n\n\n\n\n\n\n")
                #endif
                finish(output: NetworkResponse(request: input.request,
                                               httpUrlResponse: HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!,
                                               body: body,
                                               bodyOrigin: .fromCache))
                return
            }
            cache.removeObject(forKey: key)
        }
        
        // Creates data task.
        if isCancelled { return }

        #if DEBUG
        let start = self.currentTimeMillis()
        #endif
        
        task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            #if DEBUG
            self?.handle(urlRequest: urlRequest, data: data, response: response, error: error, start: start, end: self?.currentTimeMillis())
            #else
            self?.handle(urlRequest: urlRequest, data: data, response: response, error: error, start: nil, end: nil)
            #endif
        }
        
        // Start task
        task?.resume()
        return
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        #if DEBUG
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend), PROGRESS: \(progress)")
        #endif
    }
}

private extension URLSessionOperation {
    func handle(urlRequest: URLRequest, data: Data?, response: URLResponse?, error: Error?, start: Float64?, end: Float64?) {
        
        session.finishTasksAndInvalidate()
                
        if isCancelled {
            return
        }
        
        if let networkError = error {
            
            #if DEBUG
            print("\n\n\n\n\n\n🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺\n📦 REQUEST:\n\(urlRequest)\n\n🔻 ERROR:\n\(networkError.localizedDescription))\n\n\n\n\n\n\n\n\n")
            #endif
                        
            finish(error: .generic(networkError))
            return
        }
        
        guard let httpUrlResponse = response as? HTTPURLResponse else {
            finish(error: .invalidData)
            return
        }
        
        guard let body = data else {
            finish(error: .invalidData)
            return
        }
        
        let result = NetworkResponse(request: input.request, httpUrlResponse: httpUrlResponse, body: body)
        
        #if DEBUG
        printLog(request: urlRequest, response: httpUrlResponse, body: body, start: start, end: end)
        #endif
        
        if let cache = input.request.localCache,
            let key = input.request.localCacheKey,
            let ttl = input.request.ttlRequest,
            key.isEmpty == false,
            httpUrlResponse.statusCode == HTTPStatusCode.ok.rawValue,
            (httpUrlResponse.expectedContentLength > 0 || body.count > 0 || (httpUrlResponse.allHeaderFields["Content-Length"] as? Int ?? 0) > 0) {
            
            func setCacheObject() {
                cache.setObject(body, forKey: key, withTTL: ttl)
                #if DEBUG
                print("\n\n\n\n\n\n🔥🔥🔥🔥🔥🔥🔥🔥🔥\n💊 CACHE:\n\(String(describing: self.name))\nSAVE key:\(key)  ->  \(body)\n\n\n\n\n\n\n\n\n")
                #endif
            }
            
            setCacheObject()
        }
        
        finish(output: result)
    }
    
    #if DEBUG
    func printLog(request: URLRequest, response: HTTPURLResponse, body: Data, start: Float64?, end: Float64?) {
        let diff = Float64((end ?? 0) - (start ?? 0))
        let str1 = "\(diff)"
        let str2 = request.debugDescription
        let str3 = request.allHTTPHeaderFields
        let str4 = response.allHeaderFields
        let str5 = String(decoding: body, as: UTF8.self)
        let str6 = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("\n\n\n\n\n\n🔥🔥🔥🔥🔥🔥🔥🔥🔥\n📦 REQUEST:\n\(str2)\n\n💊 BODY:\n\(str6)\n\n⏰ \(str1) seconds\n\n\(str3 ?? [:])\n\n\n🏷 RESPONSE:\n\(str4))\n\n\(str5)\n\n\n\n\n\n\n\n\n")
    }
    
    func currentTimeMillis() -> Float64 {
        return Float64((NSDate().timeIntervalSince1970))
    }
    #endif
}
