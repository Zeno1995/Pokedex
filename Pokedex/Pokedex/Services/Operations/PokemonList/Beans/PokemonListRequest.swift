//
//  PokemonListRequest.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

struct PokemonListRequest {
    let offset: Int?
    let limit: Int?
    
    init(offset: Int? = nil, limit: Int? = nil) {
        self.offset = offset
        self.limit = limit
    }
}
