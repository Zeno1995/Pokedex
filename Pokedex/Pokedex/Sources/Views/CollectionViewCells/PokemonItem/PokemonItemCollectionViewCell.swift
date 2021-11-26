//
//  PokemonItemCollectionViewCell.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import UIKit

class PokemonItemCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let iView = UIImageView(image: .imageFrom(name: "Placeholder"))
        iView.contentMode = .scaleAspectFit
        iView.layer.cornerRadius = 8
        iView.layer.masksToBounds = true
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
    }()

    private lazy var label: PaddingLabel = {
        let label = PaddingLabel(topInset: 10,
                                 bottomInset: 10,
                                 leftInset: 10,
                                 rightInset: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
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
        addSubview(imageView)
        addSubview(label)

        self.imageView.anchor(top: self.topAnchor,
                              left: self.leadingAnchor,
                              bottom: self.bottomAnchor,
                              right: self.trailingAnchor)
        
        self.label.anchor(bottom: self.imageView.bottomAnchor,
                          centerX: self.imageView.centerXAnchor)
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
//            imageView.topAnchor.constraint(equalTo: topAnchor),
//            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//
//            label.leadingAnchor.constraint(greaterThanOrEqualTo: imageView.leadingAnchor),
//            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
//            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
//        ])
    }

    private func updateViewWithState() {
        self.label.isHidden = false
        if let image = state?.image ?? .imageFrom(name: "Placeholder") {
            imageView.image = image
//            let ratio = image.size.width / image.size.height
//            setAspectRatioConstraint(toRatio: ratio)
        } else {
            imageView.image = nil
        }

        TextLayout.description
            .change(backgroundColor: ColorLayout.primary)
            .apply(to: label, text: state?.name)
    }

//    private func setAspectRatioConstraint(toRatio ratio: CGFloat) {
//        imageViewAspectRatioConstraint?.isActive = false
//
//        imageViewAspectRatioConstraint = imageView.widthAnchor
//            .constraint(equalTo: imageView.heightAnchor, multiplier: ratio)
//        imageViewAspectRatioConstraint?.priority = .init(999)
//
//        imageViewAspectRatioConstraint?.isActive = true
//    }
}

extension PokemonItemCollectionViewCell {
    struct State {
        var image: UIImage?
        var name: String?
    }
}
