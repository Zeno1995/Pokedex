//
//  ImageDownloadOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation
import UIKit

final class ImageOperation: StandardOperation<String, UIImage?, ServiceError> {

    override func perform() throws {
        let sessionService: SessionService = try container.resolve()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            sessionService.imageCache().image(for: self.input, completion: { [weak self] image in
                guard let self = self else { return }
                let finalImage: UIImage?
                if let image = image {
                    finalImage = image
                } else if let image = UIImage.imageFrom(url: self.input) {
                    sessionService.imageCache().insert(image, forUrl: self.input)
                    finalImage = image
                } else {
                    finalImage = nil
                }
                DispatchQueue.main.async {
                    self.finish(output: finalImage)
                }
            })
        }
    }
}
