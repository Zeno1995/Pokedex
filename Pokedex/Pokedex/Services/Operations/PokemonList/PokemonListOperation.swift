//
//  PokemonListOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

final class PokemonListOperation: StandardOperation<PokemonListRequest, PokemonListResponse, ServiceError> {

    private typealias This = PokemonListOperation
    private static let endPoint = "/pokemon"

    override func perform() throws {
        
        var params: [String: String] = [:]
        if let limit = self.input.limit {
            params["limit"] = String(limit)
        }
        if let offset = self.input.offset {
            params["offset"] = String(offset)
        }

        let request = NetworkRequest(method: .get,
                                     path: This.endPoint,
                                     queryParams: params)

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
        "\(This.endPoint)"
    }
}
