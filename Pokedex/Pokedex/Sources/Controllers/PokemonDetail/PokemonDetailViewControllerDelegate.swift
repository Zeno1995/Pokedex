//
//  PokemonDetailViewControllerDelegate.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

protocol PokemonDetailViewControllerDelegate: AnyObject {
    func viewDidLoaded()
    func showMoveDetail(withId moveId: String)
}
