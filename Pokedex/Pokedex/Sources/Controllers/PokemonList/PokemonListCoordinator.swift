//
//  PokemonListCoordinator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

final class PokemonListCoordinator: VoidCoordinator<PokemonListViewController> {
    private func loadPokemonList(offset: Int = 0) {
        self.context.messenger.loader.showLoading()
        let input = PokemonListRequest(offset: offset, limit: 100)
        self.context.core.pokeServices.pokemonList(from: input,
                                                   stubFlag: false) { [weak self] result in
            guard let self = self else { return }
            self.context.messenger.loader.stopLoading()
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let results = response.results else { return }
                    results.forEach({ self.view.pokemonList.append(PokemonListImageItem(item: $0))})
                case .failure(let error):
                    self.context.messenger.alert.showAlert(title: Localizer.Alert.error.localized, description: error.localizedDescription)
                }
            }
        }
    }
}

extension PokemonListCoordinator: PokemonListViewControllerDelegate {
    
    func viewDidLoaded() {
        self.loadPokemonList()
    }
    
    func showPokemonDetail(withId pokemonId: String) {
        let param = PokemonDetailParam(pokemonId: pokemonId)
        let coordinator = PokemonDetailCoordinator(context: self.context, param: param)
        self.context.navigator.navigate(to: coordinator, animated: true)
        
    }
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        context.core.pokeServices.downloadImage(input: url.absoluteString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    completion(image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    func loadOtherPokemon(offset: Int) {
        self.loadPokemonList(offset: offset)
    }
    
}
