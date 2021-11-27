//
//  PokemonStat.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 27/11/21.
//

import Foundation

struct PokemonStat: Decodable {
    let baseStat: Int?
    let effort: Int?
    let stat: Stat?
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat",
             effort,
             stat
    }
    
    struct Stat: Decodable {
        let name: String?
        let url: String?
    }
}
