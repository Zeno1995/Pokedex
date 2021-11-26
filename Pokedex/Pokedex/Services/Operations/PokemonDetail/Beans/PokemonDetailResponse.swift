//
//  PokemonDetailResponse.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

struct PokemonDetailResponse: Decodable {
    let pokemonId: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case pokemonId = "id"
        case name
    }
}
