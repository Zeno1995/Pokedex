//
//  PokeServiceCore.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation
import UIKit

final class PokeServiceCore: BaseService, PokeService {
    func pokemonList(from input: PokemonListRequest,
                     stubFlag: Bool?,
                     completion: @escaping Completion<PokemonListResponse, ServiceError>) -> Operation {
        execute(PokemonListOperation(input: input, container: container, useStub: stubFlag), completion: completion)
    }
    
    func pokemonDetail(from input: PokemonDetailRequest,
                     stubFlag: Bool?,
                     completion: @escaping Completion<PokemonDetailResponse, ServiceError>) -> Operation {
        execute(PokemonDetailOperation(input: input, container: container, useStub: stubFlag), completion: completion)
    }
    
    func downloadImage(input: String, completion: @escaping Completion<UIImage?, ServiceError>) -> Operation {
        execute(ImageOperation(input: input, container: container, useStub: nil), completion: completion)
    }
}
