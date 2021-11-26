//
//  PokemonListCoordinator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class PokemonListCoordinator: VoidCoordinator<PokemonListViewController> {
    private func loadPokemonList() {
        self.context.messenger.loader.showLoading()
        let input = PokemonListRequest(offset: 0, limit: 100)
        self.context.core.pokeServices.pokemonList(from: input,
                                                   stubFlag: false) { [weak self] result in
            guard let self = self else { return }
            self.context.messenger.loader.stopLoading()
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                self.context.messenger.alert.showAlert(title: "Errore!", description: error.localizedDescription)
            }
        }
    }
}

extension PokemonListCoordinator: PokemonListViewControllerDelegate {
    
    func viewDidLoaded() {
        self.loadPokemonList()
    }
    
    func goToDetail(withId id: Int) {
        let param = PokemonDetailParam(pokemonId: id)
        let coordinator = PokemonDetailCoordinator(context: self.context, param: param)
        self.context.navigator.navigate(to: coordinator, animated: true)
    }
}
