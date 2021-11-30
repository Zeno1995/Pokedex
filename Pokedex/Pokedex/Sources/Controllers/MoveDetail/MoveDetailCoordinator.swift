//
//  MoveDetailCoordinator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 29/11/21.
//

import Foundation

final class MoveDetailCoordinator: BaseCoordinator<MoveDetailViewController, MoveDetailParam> {
    private func loadMove() {
        self.context.messenger.loader.showLoading()
        let request = MoveDetailRequest(moveId: self.param.moveId)
        self.context.core.pokeServices.moveDetail(from: request, stubFlag: false) { [weak self] result in
            guard let self = self else { return }
            self.context.messenger.loader.stopLoading()
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.view.loadMoves(response: response)
                }
            case .failure(let error):
                self.context.messenger.alert.showAlert(title: "Errore", description: error.localizedDescription)
            }
        }
    }
}

extension MoveDetailCoordinator: MoveDetailViewControllerDelegate {
    func viewDidLoaded() {
        self.loadMove()
    }
    
    func showPokemonDetail(withId pokemonId: String) {
        let param = PokemonDetailParam(pokemonId: pokemonId)
        let coordinator = PokemonDetailCoordinator(context: self.context, param: param)
        self.context.navigator.navigate(to: coordinator, animated: true)
    }
}
