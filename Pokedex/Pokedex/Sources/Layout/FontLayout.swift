//
//  FontLayout.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

enum FontWeight: String, CaseIterable {
    case light = "-Light"
    case regular = "-Regular"
    case semibold = "-SemiBold"
    case medium = "-Medium"
    case bold = "-Bold"
}

extension FontWeight {
    static func loadAllFonts() {
        let styles = allCases.map { $0.rawValue }
        
        styles.forEach { styleString in
            guard let fontUrl = Bundle.main.url(forResource: styleString, withExtension: "ttf") else { return }
            guard let fontData = try? Data(contentsOf: fontUrl) else { return }
            guard let fontProvider = CGDataProvider(data: fontData as CFData) else { return }
            guard let fontRef = CGFont(fontProvider) else { return }
            var errorFont: Unmanaged<CFError>?
            if CTFontManagerRegisterGraphicsFont(fontRef, &errorFont) {
                print("Font loaded: \(styleString), error: \(errorFont.debugDescription)")
            }
        }
    }
}

enum FontLayout {
    private static var fontSizeBaseUnit: CGFloat {
        let width = UIScreen.main.bounds.width
        let size: CGFloat = width >= 360 ? 15 : 13
        return size
    }
    
    static func font(size: CGFloat, weight: FontWeight = .regular) -> UIFont {
        let fontName = "Monserract" + weight.rawValue
        let font = UIFont(name: fontName, size: size)
        if let current = font {
            return current
        }
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func font(rel: Float, weight: FontWeight = .regular) -> UIFont {
        let size = fontSizeBaseUnit * CGFloat(rel)
        return font(size: size, weight: weight)
    }
}
