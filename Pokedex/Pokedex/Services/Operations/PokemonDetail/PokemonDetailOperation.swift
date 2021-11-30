//
//  PokemonDetailOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

final class PokemonDetailOperation: StandardOperation<PokemonDetailRequest, PokemonDetailResponse, ServiceError> {

    lazy var endPoint: String = {
        return "/pokemon/\(self.input.id)"
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
            .then(MappingOperation<PokemonDetailResponse>.self)
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
