//
//  MoveDetailViewController.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 29/11/21.
//

import Foundation
import UIKit

final class MoveDetailViewController: ScrollableStackViewController<MoveDetailViewControllerDelegate> {
    
    lazy var pokemonTitleLabel: UILabel = {
        let label = UILabel()
        TextLayout.title
            .apply(to: label, text: Localizer.MoveDetail.pokemonTitle.localized)
        return label
    }()
    
    let cellReuseIdentifier = "pokeListCell"
    lazy var pokemonTableView: IntrinsicTableView = {
       let tableView = IntrinsicTableView()
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    var learnedByPokemonList = [MoveLearn]() {
        didSet {
            self.pokemonTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coordinator.viewDidLoaded()
    }
    
    func loadMoves(response: MoveDetailResponse) {
        self.title = response.name
        
        if let effects = response.effectEntries {
            for effect in effects {
                let shortLabel = UILabel()
                shortLabel.numberOfLines = 0
                TextLayout.subtitle.apply(to: shortLabel, text: effect.shortEffect)
                self.containerStackView.addArrangedSubview(shortLabel)
                
                let effectLabel = UILabel()
                effectLabel.numberOfLines = 0
                TextLayout.description.apply(to: effectLabel, text: effect.effect)
                self.containerStackView.addArrangedSubview(effectLabel)
                
                self.addSeparatorView()
            }
        }
        
        if let learnedByPokemon = response.learnedByPokemon, !learnedByPokemon.isEmpty {
            self.containerStackView.addArrangedSubview(self.pokemonTitleLabel)
            self.containerStackView.addArrangedSubview(self.pokemonTableView)
            self.learnedByPokemonList = learnedByPokemon
        }
    }
}

extension MoveDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.learnedByPokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) {
            cell.textLabel?.text = self.learnedByPokemonList[indexPath.row].name.stringOrEmpty
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.learnedByPokemonList[indexPath.row]
        if let url = URL(string: item.url.stringOrEmpty) {
            self.coordinator.showPokemonDetail(withId: url.lastPathComponent)
        }
    }
}
