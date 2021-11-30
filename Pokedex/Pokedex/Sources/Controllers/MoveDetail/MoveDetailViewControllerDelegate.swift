//
//  MoveDetailViewControllerDelegate.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 29/11/21.
//

import Foundation

protocol MoveDetailViewControllerDelegate: AnyObject {
    func viewDidLoaded()
    func showPokemonDetail(withId pokemonId: String)
}
