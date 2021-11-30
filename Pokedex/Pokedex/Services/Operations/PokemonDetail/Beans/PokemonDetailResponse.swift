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
    
    let sprites: PokemonSprite?
    let moves: [PokemonMove]?
    let stats: [PokemonStat]?
    
    enum CodingKeys: String, CodingKey {
        case pokemonId = "id",
             name,
             sprites,
             moves,
             stats
    }
}
