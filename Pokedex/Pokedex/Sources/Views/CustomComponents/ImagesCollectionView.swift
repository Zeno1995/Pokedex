//
//  ImagesCollectionView.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 28/11/21.
//

import Foundation
import UIKit

class ImagesCollectionView: UICollectionView {

    var images: [UIImage]? {
        didSet {
            self.reloadData()
        }
    }
    var urlImages: [String]? {
        didSet {
            self.reloadData()
        }
    }

    var itemSize: CGFloat?

    public typealias CompletionBlock = ((UIImage) -> Void)
    var onSelected: CompletionBlock?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(frame: CGRect,
         collectionViewLayout layout: UICollectionViewLayout,
         itemSize: CGFloat,
         onSelected: @escaping CompletionBlock) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
        self.allowsMultipleSelection = false
        self.backgroundColor = ColorLayout.clear
        self.showsHorizontalScrollIndicator = false
        self.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))

        self.clipsToBounds = false

        self.itemSize = itemSize

        self.onSelected = onSelected
    }
}

extension ImagesCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? urlImages?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ImageCollectionViewCell.self),
            for: indexPath) as? ImageCollectionViewCell {
            if let url = urlImages?[indexPath.row] {
                cell.loadImage(url: url)
            } else if let image = images?[indexPath.row] {
                cell.set(image: image)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell,
           let image = cell.imageView.image {
            self.onSelected?(image)
        }
    }
}

extension ImagesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemSize ?? 0, height: self.itemSize ?? 0)
    }
}

