//
//  UIImage.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation
import UIKit

extension UIImage {
    
    enum JPEGQuality: CGFloat {
            case lowest = 0
            case low = 0.25
            case medium = 0.5
            case high = 0.75
            case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    static func imageFrom(name: String) -> UIImage? {
        UIImage(named: name, in: Bundle.main, compatibleWith: nil)
    }
    
    static func imageFrom(url: String) -> UIImage? {
        if let url = URL(string: url), let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
