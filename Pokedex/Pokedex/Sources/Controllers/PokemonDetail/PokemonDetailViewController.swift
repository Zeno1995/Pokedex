//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class PokemonDetailViewController: ScrollableStackViewController<PokemonDetailViewControllerDelegate> {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coordinator.viewDidLoaded()
    }
    
    func loadDetailResponse(_ response: PokemonDetailResponse) {
        if let stats = response.stats {
            for stat in stats {
                let statView = StatView()
                statView.load(withStatName: (stat.stat?.name).stringOrEmpty, andValue: stat.baseStat ?? 0)
                self.containerStackView.addArrangedSubview(statView)
            }
        }
    }
}
