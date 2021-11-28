//
//  PokemonListViewControllerDelegate.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

protocol PokemonListViewControllerDelegate: AnyObject {
    
    func viewDidLoaded()
    func showPokemonDetail(withId pokemonId: String)
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}
