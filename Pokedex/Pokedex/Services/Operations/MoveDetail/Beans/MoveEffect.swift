//
//  MoveEffect.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 29/11/21.
//

import Foundation

struct MoveEffect: Decodable {
    let effect: String?
    let shortEffect: String?
    
    enum CodingKeys: String, CodingKey {
        case effect,
             shortEffect = "short_effect"
    }
}
