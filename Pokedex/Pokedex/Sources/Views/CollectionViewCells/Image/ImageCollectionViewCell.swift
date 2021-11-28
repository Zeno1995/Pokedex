//
//  ImageCollectionViewCell.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 28/11/21.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override var isSelected: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        
        self.imageView.anchor(top: self.topAnchor,
                              left: self.leadingAnchor,
                              bottom: self.bottomAnchor,
                              right: self.trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(url: String) {
        self.imageView.loadImageFrom(url: url, inContext: nil)
    }

    func set(image: UIImage) {
        self.imageView.image = image
    }

    func onSelected(_ newValue: Bool) {
        if newValue {
            self.imageView.layer.borderWidth = 1
            self.imageView.layer.borderColor = ColorLayout.primary.cgColor
        } else {
            self.imageView.layer.borderWidth = 0
        }
    }
}
