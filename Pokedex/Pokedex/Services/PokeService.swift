//
//  PokeService.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

protocol PokeService: Service {
    @discardableResult
    func pokemonList(from input: PokemonListRequest,
                     stubFlag: Bool?,
                     completion: @escaping Completion<PokemonListResponse, ServiceError>) -> Operation
}
