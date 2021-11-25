//
//  Statistics.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

struct Statistics {
    
    internal(set) var hits = 0
    internal(set) var misses = 0
    internal(set) var numberOfKeys = 0
    
    mutating func reset() {
        hits = 0
        misses = 0
        numberOfKeys = 0
    }
}
