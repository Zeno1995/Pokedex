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
    func goToDetail(withId id: Int)
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}
