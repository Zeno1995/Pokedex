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
            guard let self = self else { return }
            self.context.messenger.loader.stopLoading()
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.view.loadDetailResponse(response)
                case .failure(let error):
                    self.context.messenger.alert.showAlert(title: "Errore", description: error.localizedDescription)
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
