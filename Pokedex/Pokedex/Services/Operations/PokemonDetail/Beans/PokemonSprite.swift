//
//  PokemonSprite.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation

struct PokemonSprite: Decodable {
    let backDefault: String?
    let backFemaile: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default",
             backFemaile = "back_female",
             backShiny = "back_shiny",
             backShinyFemale = "back_shiny_female",
             frontDefault = "front_default",
             frontFemale = "front_female",
             frontShiny = "front_shiny",
             frontShinyFemale = "front_shiny_female"
    }
    
    func imagesUlr() -> [String] {
        var imagesUrl = [String]()
        if let url = backDefault {
            imagesUrl.append(url)
        }
        
        if let url = backFemaile {
            imagesUrl.append(url)
        }
        
        if let url = backShiny {
            imagesUrl.append(url)
        }
        
        if let url = backShinyFemale {
            imagesUrl.append(url)
        }
        
        if let url = frontDefault {
            imagesUrl.append(url)
        }
        
        if let url = frontFemale {
            imagesUrl.append(url)
        }
        
        if let url = frontShiny {
            imagesUrl.append(url)
        }
        
        if let url = frontShinyFemale {
            imagesUrl.append(url)
        }
        
        return imagesUrl
    }
}
