//
//  Localizer.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

protocol Localizable {
    var localizedKey: String { get }
}

extension Localizable {
    var localizedKey: String { return "poke" }
}

enum Localizer {
}
