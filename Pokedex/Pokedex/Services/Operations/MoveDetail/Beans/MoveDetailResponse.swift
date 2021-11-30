//
//  MoveDetailResponse.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 29/11/21.
//

import Foundation

struct MoveDetailResponse: Decodable {
    
    let name: String?
    let learnedByPokemon: [MoveLearn]?
    let effectEntries: [MoveEffect]?
    
    enum CodingKeys: String, CodingKey {
        case name,
             learnedByPokemon = "learned_by_pokemon",
             effectEntries = "effect_entries"
    }
}
