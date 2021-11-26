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
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Go to detail page", for: .normal)
        button.addTarget(self, action: #selector(goToDetail(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.anchor(top: self.view.safeTopAnchor, paddingTop: 32, centerX: self.view.centerXAnchor)
        
        self.view.addSubview(self.button)
        self.button.anchor(top: self.titleLabel.topAnchor, paddingTop: 32, centerX: self.view.centerXAnchor)
        
        self.coordinator.viewDidLoaded()
    }
    
    @IBAction func goToDetail(_ sender: UIButton) {
        self.coordinator.goToDetail(withId: 0)
    }
}
