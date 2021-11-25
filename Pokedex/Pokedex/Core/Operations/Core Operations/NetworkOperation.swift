//
//  NetworkOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class NetworkOperation: StandardOperation<NetworkRequest, NetworkResponse, ServiceError> {
    var counter = 0
    
    override func perform() throws {
        var req = self.input
        
        // gestione Cache
        if self.noCache == true, let cacheReq = req.localCache, let keyReq = req.localCacheKey, keyReq.isEmpty == false, let ttlReq = req.ttlRequest, ttlReq > UInt.zero {
            cacheReq.removeObject(forKey: keyReq)
        }
        
        #if DEBUG
        //Gestione Stub su localhost
        if self.useStub == true, let env = self.stubEnvironment() {
            req.update(environment: env)
        }
        #endif
        
        try self.performNetwork(request: req)
    }
}

extension NetworkOperation {
    func performNetwork(request: NetworkRequest) throws {
        let network: Network = try container.resolve()
        let op = network.perform(request: request) { [weak self] result in
            switch result {
            case let .success(response):
                self?.finish(output: response)
            case let .failure(error):
                self?.finish(error: ServiceError.map(error: error))
            }
        }
        
        addTask(task: op)
    }
}
    
