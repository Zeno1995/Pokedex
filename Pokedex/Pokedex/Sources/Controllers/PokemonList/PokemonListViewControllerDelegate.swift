//
//  PokemonListViewControllerDelegate.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

protocol PokemonListViewControllerDelegate: AnyObject {
    func goToDetail(withId id: Int)
}
