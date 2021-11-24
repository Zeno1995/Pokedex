//
//  TextLayout+Extension.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

extension TextLayout {
    static var buttonFull: TextLayout = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byTruncatingTail
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontLayout.font(rel: 1, weight: .bold),
            .foregroundColor: ColorLayout.white,
            .paragraphStyle: style,
            .kern: 0
        ]
        
        return TextLayout(attributes: attributes)
    }()
    
    static var textField: TextLayout = {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byTruncatingTail
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontLayout.font(rel: 1.0, weight: .regular),
            .foregroundColor: ColorLayout.black,
            .backgroundColor: ColorLayout.clear,
            .paragraphStyle: style,
            .kern: 0
        ]
        
        return TextLayout(attributes: attributes)
    }()
}
