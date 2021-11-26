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
    
    private lazy var pokemonCollectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    private lazy var pokemonCollectionView: UICollectionView = {
        let cView = UICollectionView(frame: .zero, collectionViewLayout: pokemonCollectionViewLayout)
        cView.backgroundColor = .clear
        cView.isScrollEnabled = true
        cView.register(PokemonItemCollectionViewCell.self, forCellWithReuseIdentifier: PokemonItemCollectionViewCell.identifier)
        cView.dataSource = self
        cView.delegate = self
        return cView
    }()
    
    var pokemonList = [PokemonListImageItem]() {
        didSet {
            self.pokemonCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
//        self.view.addSubview(self.titleLabel)
//        self.titleLabel.anchor(top: self.view.safeTopAnchor, paddingTop: 32, centerX: self.view.centerXAnchor)
//        
//        self.view.addSubview(self.button)
//        self.button.anchor(top: self.titleLabel.topAnchor, paddingTop: 32, centerX: self.view.centerXAnchor)
        
        self.view.addSubview(self.pokemonCollectionView)
        self.pokemonCollectionView.anchor(top: self.view.safeTopAnchor,
                                          left: self.view.leadingAnchor,
                                          bottom: self.view.safeBottomAnchor,
                                          right: self.view.trailingAnchor)
        
        self.coordinator.viewDidLoaded()
    }
    
    private func updateItemImage(at indexPath: IndexPath, newImage: UIImage?) {
        guard let image = newImage else { return }
        pokemonList[indexPath.item].image = image
        pokemonCollectionView.reloadItems(at: [indexPath])
    }
    
    @IBAction func goToDetail(_ sender: UIButton) {
        self.coordinator.goToDetail(withId: 0)
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PokemonItemCollectionViewCell.identifier,
                for: indexPath
            ) as? PokemonItemCollectionViewCell
        else {
            assertionFailure()
            return UICollectionViewCell()
        }

        let pokemonItem = pokemonList[indexPath.item]

        cell.state = .init(image: pokemonItem.image, name: pokemonItem.name)
        
        if let urlString = pokemonItem.url,
           let url = URL(string: urlString),
           pokemonItem.image == nil {
            let pokemonId = url.lastPathComponent
            if let imageUrl = Constants.imagePath(withPokemonId: pokemonId) {
                self.coordinator.fetchImage(from: imageUrl) { [weak self] image in
                    self?.updateItemImage(at: indexPath, newImage: image)
                }
            }
        }
        return cell
    }
    
    
}
