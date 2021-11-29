//
//  PokemonItemCollectionViewCell.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import UIKit

class PokemonItemCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addShadow()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let iView = UIImageView(image: .imageFrom(name: "Placeholder"))
        iView.contentMode = .scaleAspectFit
        iView.layer.cornerRadius = 8
        iView.layer.masksToBounds = true
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
    }()

    private lazy var label: PaddingLabel = {
        let label = PaddingLabel(topInset: 2,
                                 bottomInset: 2,
                                 leftInset: 6,
                                 rightInset: 6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = ColorLayout.primary
        label.numberOfLines = 0
        return label
    }()

    private var imageViewAspectRatioConstraint: NSLayoutConstraint?

    static let identifier: String = .init(describing: PokemonItemCollectionViewCell.self)
    static let widthToHeightRatio: CGFloat = 1

    var state: State? {
        didSet {
            updateViewWithState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.addSubview(self.containerView)
        self.containerView.anchor(top: self.topAnchor,
                              left: self.leadingAnchor,
                              bottom: self.bottomAnchor,
                              right: self.trailingAnchor)
        
        self.containerView.addSubview(imageView)
        self.containerView.addSubview(label)

        self.imageView.anchor(top: self.containerView.topAnchor,
                              left: self.containerView.leadingAnchor,
                              bottom: self.containerView.bottomAnchor,
                              right: self.containerView.trailingAnchor)
        
        self.label.anchor(bottom: self.containerView.bottomAnchor,
                          width: 80,
                          centerX: self.containerView.centerXAnchor)
        
        self.label.widthAnchor.constraint(equalToConstant: 88).isActive = true
        
        self.containerView.layer.borderColor = ColorLayout.primary.cgColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.cornerRadius = 16
        self.imageView.layer.cornerRadius = 16
    }

    private func updateViewWithState() {
        self.label.isHidden = false
        if let image = state?.image ?? .imageFrom(name: "Placeholder") {
            imageView.image = image
        } else {
            imageView.image = nil
        }

        TextLayout.description
            .change(backgroundColor: ColorLayout.primary)
            .change(textAlignment: .center)
            .apply(to: label, text: state?.name)
    }
}

extension PokemonItemCollectionViewCell {
    struct State {
        var image: UIImage?
        var name: String?
    }
}
