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
    
    static var description: TextLayout = {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byTruncatingTail
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontLayout.font(size: 14, weight: .regular),
            .foregroundColor: ColorLayout.black,
            .backgroundColor: ColorLayout.clear,
            .paragraphStyle: style,
            .kern: 0
        ]
        
        return TextLayout(attributes: attributes)
    }()
    
    static var title: TextLayout = {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byTruncatingTail
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontLayout.font(size: 22, weight: .bold),
            .foregroundColor: ColorLayout.black,
            .backgroundColor: ColorLayout.clear,
            .paragraphStyle: style,
            .kern: 0
        ]
        
        return TextLayout(attributes: attributes)
    }()
    
    static var subtitle: TextLayout = {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byTruncatingTail
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontLayout.font(size: 18, weight: .semibold),
            .foregroundColor: ColorLayout.black,
            .backgroundColor: ColorLayout.clear,
            .paragraphStyle: style,
            .kern: 0
        ]
        
        return TextLayout(attributes: attributes)
    }()
}
