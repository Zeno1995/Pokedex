//
//  PokemonListCoordinator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class PokemonListCoordinator: VoidCoordinator<PokemonListViewController> {
    
}

extension PokemonListCoordinator: PokemonListViewControllerDelegate {
    func goToDetail(withId id: Int) {
        let param = PokemonDetailParam(pokemonId: id)
        let coordinator = PokemonDetailCoordinator(context: self.context, param: param)
        self.context.navigator.navigate(to: coordinator, animated: true)
    }
}
