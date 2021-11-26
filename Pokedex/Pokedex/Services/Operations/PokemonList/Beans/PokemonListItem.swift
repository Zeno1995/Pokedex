//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation
import UIKit

struct PokemonListItem: Decodable {
    let name: String?
    let url: String?
}

struct PokemonListImageItem {
    let name: String?
    let url: String?
    var image: UIImage?
    
    init(item: PokemonListItem) {
        self.name = item.name
        self.url = item.url
        self.image = nil
    }
}
