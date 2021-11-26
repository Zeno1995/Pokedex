//
//  Dictionary.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

extension Dictionary where Key == NSAttributedString.Key {
    func toTypingAttributes() -> [NSAttributedString.Key : Any] {
        var convertedDictionary = [NSAttributedString.Key : Any]()

        for (key, value) in self {
            convertedDictionary[key] = value
        }

        return convertedDictionary
    }
}
