//
//  PokemonListOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

final class PokemonListOperation: StandardOperation<PokemonListRequest, PokemonListResponse, ServiceError> {

    private let endPoint = "/pokemon"
    let ttl: UInt = 86_400 // 24 ore

    override func perform() throws {
        
        var params: [String: String] = [:]
        if let limit = self.input.limit {
            params["limit"] = String(limit)
        }
        if let offset = self.input.offset {
            params["offset"] = String(offset)
        }

        let request = NetworkRequest(method: .get,
                                     path: endPoint,
                                     queryParams: params,
                                     localCache: cache(),
                                     localCacheKey: key(),
                                     ttlRequest: ttl)

        begin(with: NetworkOperation.self, input: request, stubFlag: self.useStub, noCache: self.noCache)
            .then(StatusCodeOperation.self)
            .then(MappingOperation<PokemonListResponse>.self)
            .success { [weak self] response in
                self?.finish(output: response)
            }
            .catchAll { [weak self] error in
                self?.finish(error: ServiceError.map(error: error))
            }
    }

    private func key() -> String? {
        "\(endPoint)?limit=\(self.input.limit ?? 0)&\(self.input.offset ?? 0)"
    }
}
