//
//  MoveDetailOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 29/11/21.
//

import Foundation

final class MoveDetailOperation: StandardOperation<MoveDetailRequest, MoveDetailResponse, ServiceError> {

    lazy var endPoint: String = {
        return "/move/\(self.input.moveId)"
    }()
    
    let ttl: UInt = 86_400 // 24 ore

    override func perform() throws {
        let request = NetworkRequest(method: .get,
                                     path: endPoint,
                                     localCache: cache(),
                                     localCacheKey: key(),
                                     ttlRequest: ttl)

        begin(with: NetworkOperation.self, input: request, stubFlag: self.useStub, noCache: self.noCache)
            .then(StatusCodeOperation.self)
            .then(MappingOperation<MoveDetailResponse>.self)
            .success { [weak self] response in
                self?.finish(output: response)
            }
            .catchAll { [weak self] error in
                self?.finish(error: ServiceError.map(error: error))
            }
    }

    private func key() -> String? {
        endPoint
    }
}
