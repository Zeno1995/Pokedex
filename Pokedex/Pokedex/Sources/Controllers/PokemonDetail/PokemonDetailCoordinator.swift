//
//  PokemonDetailCoordinator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class PokemonDetailCoordinator: BaseCoordinator<PokemonDetailViewController, PokemonDetailParam> {
    func getPokemonDetail() {
        self.context.messenger.loader.showLoading()
        let input = PokemonDetailRequest(id: self.param.pokemonId)
        self.context.core.pokeServices.pokemonDetail(from: input, stubFlag: false) { [weak self] result in
            self?.context.messenger.loader.stopLoading()
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    self?.context.messenger.alert.showAlert(title: "Errore", description: error.localizedDescription)
                }
            }
        }
    }
}

extension PokemonDetailCoordinator: PokemonDetailViewControllerDelegate {
    func viewDidLoaded() {
        self.getPokemonDetail()
    }
}
