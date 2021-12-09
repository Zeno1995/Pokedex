//
//  PokemonMove.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 09/12/21.
//

import Foundation

struct PokemonMove: Decodable {
    let move: Move?
}

struct Move: Decodable {
    let name: String?
    let url: String?
}
