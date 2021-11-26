//
//  PokemonListResponse.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

struct PokemonListResponse: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonListItem]?
}


