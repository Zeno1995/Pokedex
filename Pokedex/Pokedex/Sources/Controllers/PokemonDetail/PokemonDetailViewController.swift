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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coordinator.viewDidLoaded()
    }
    
    override func loadStackView() {
        super.loadStackView()
        
        self.containerStackView.addArrangedSubview(pokemonImageView)
        self.containerStackView.addArrangedSubview(imagesCollectionView)
    }
    
    func loadDetailResponse(_ response: PokemonDetailResponse) {
        if let stats = response.stats {
            for stat in stats {
                let statView = StatView()
                statView.load(withStatName: (stat.stat?.name).stringOrEmpty, andValue: stat.baseStat ?? 0)
                self.containerStackView.addArrangedSubview(statView)
            }
        }
        
        self.title = response.name
        
        if let imagesUlr = response.sprites?.imagesUlr(), !imagesUlr.isEmpty {
            self.imagesCollectionView.urlImages = imagesUlr
            self.pokemonImageView.loadImageFrom(url: imagesUlr[0], inContext: nil)
        } else {
            self.pokemonImageView.isHidden = true
            self.pokemonImageView.isHidden = true
        }
    }
}
