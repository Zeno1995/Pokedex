//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

final class PokemonDetailViewController: ScrollableStackViewController<PokemonDetailViewControllerDelegate> {
    
    let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.anchor(height: 150)
        return imageView
    }()
    
    lazy var imagesCollectionView: ImagesCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collection = ImagesCollectionView(frame: CGRect.zero,
                                              collectionViewLayout: layout,
                                              itemSize: 40) { [weak self] selectedImage in
            guard let self = self else { return }
            self.pokemonImageView.image = selectedImage
        }
        collection.anchor(height: 40)
        return collection
    }()
    
    lazy var abilitiesTitleLabel: UILabel = {
        let label = UILabel()
        TextLayout.title
            .apply(to: label, text: Localizer.PokemonDetail.abilities.localized)
        return label
    }()
    
    lazy var movesTitleLabel: UILabel = {
        let label = UILabel()
        TextLayout.title
            .apply(to: label, text: Localizer.PokemonDetail.moveTitle.localized)
        return label
    }()
    
    let cellReuseIdentifier = "moveListCell"
    lazy var moveTableView: IntrinsicTableView = {
       let tableView = IntrinsicTableView()
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    var movesList = [PokemonMove]() {
        didSet {
            self.moveTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coordinator.viewDidLoaded()
    }
    
    override func loadStackView() {
        super.loadStackView()
        
        self.containerStackView.addArrangedSubview(pokemonImageView)
        self.containerStackView.addArrangedSubview(imagesCollectionView)
        self.addSeparatorView()
    }
    
    func loadDetailResponse(_ response: PokemonDetailResponse) {
        self.title = response.name
        
        if let stats = response.stats {
            self.containerStackView.addArrangedSubview(self.abilitiesTitleLabel)
            for stat in stats {
                let statView = StatView()
                statView.load(withStatName: (stat.stat?.name).stringOrEmpty, andValue: stat.baseStat ?? 0)
                self.containerStackView.addArrangedSubview(statView)
            }
        }
        
        self.addSeparatorView()
        
        if let imagesUlr = response.sprites?.imagesUlr(), !imagesUlr.isEmpty {
            self.imagesCollectionView.urlImages = imagesUlr
            self.pokemonImageView.loadImageFrom(url: imagesUlr[0], inContext: nil)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.imagesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        } else {
            self.pokemonImageView.isHidden = true
            self.pokemonImageView.isHidden = true
        }
        
        if let moves = response.moves, !moves.isEmpty {
            self.containerStackView.addArrangedSubview(self.movesTitleLabel)
            self.containerStackView.addArrangedSubview(self.moveTableView)
            self.movesList = moves
        }
    }
}

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) {
            cell.textLabel?.text = self.movesList[indexPath.row].move?.name.stringOrEmpty
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.movesList[indexPath.row]
        if let move = item.move, let url = URL(string: move.url.stringOrEmpty) {
            self.coordinator.showMoveDetail(withId: url.lastPathComponent)
        }
    }
}
