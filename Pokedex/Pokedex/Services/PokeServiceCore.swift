//
//  PokeServiceCore.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

final class PokeServiceCore: BaseService, PokeService {
    func pokemonList(from input: PokemonListRequest,
                     stubFlag: Bool?,
                     completion: @escaping Completion<PokemonListResponse, ServiceError>) -> Operation {
        execute(PokemonListOperation(input: input, container: container, useStub: stubFlag), completion: completion)
    }
}
