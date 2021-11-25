//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

final class PokemonListViewController: BaseViewController<PokemonListViewControllerDelegate> {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        TextLayout.textField.apply(to: label, text: "Pokemon list!")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        self.view.addSubview(titleLabel)
        self.titleLabel.anchor(top: self.view.safeTopAnchor, paddingTop: 32, centerX: self.view.centerXAnchor)
    }
}
