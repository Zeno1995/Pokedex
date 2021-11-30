//
//  UIImageView.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 28/11/21.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFrom(url: String, inContext context: Context?, completion: ((UIImageView) -> Void)? = nil) {
        guard let context = context else {
            DispatchQueue.global().async {
                if let url = URL(string: url), let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                }
            }
            return
        }
        context.core.pokeServices.downloadImage(input: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.image = image
            case .failure:
                self.image = nil
            }
            completion?(self)
        }
    }
}
