//
//  Statistics.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

struct Statistics {
    
    var hits = 0
    var misses = 0
    var numberOfKeys = 0
    
    mutating func reset() {
        hits = 0
        misses = 0
        numberOfKeys = 0
    }
}
