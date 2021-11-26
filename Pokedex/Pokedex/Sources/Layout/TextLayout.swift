//
//  TextLayout.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

struct TextLayout {
    var options: [NSAttributedString.DocumentReadingOptionKey: Any]
    let attributes: [NSAttributedString.Key: Any]
    
    var font: UIFont {
        return attributes[NSAttributedString.Key.font] as? UIFont ?? UIFont()
    }
    
    var foregroundColor: UIColor {
        return attributes[NSAttributedString.Key.foregroundColor] as? UIColor ?? ColorLayout.clear
    }
    
    var backgroundColor: UIColor {
        return attributes[NSAttributedString.Key.backgroundColor] as? UIColor ?? ColorLayout.clear
    }
    
    var underlineColor: UIColor {
        return attributes[NSAttributedString.Key.underlineColor] as? UIColor ?? ColorLayout.gray
    }
    
    var textAlignment: NSTextAlignment {
        guard let paragraph = attributes[.paragraphStyle] as? NSParagraphStyle else { return .left }
        return paragraph.alignment
    }
    
    init(attributes: [NSAttributedString.Key: Any], highlightedAttributes: [NSAttributedString.Key: Any]? = nil, options: [NSAttributedString.DocumentReadingOptionKey: Any] = [:], isHtml: Bool = false) {
        self.options = options
        self.attributes = attributes
    }
}

extension TextLayout {
    func change(fontSize: CGFloat, weight: FontWeight) -> TextLayout {
        var newAttributes = attributes
        newAttributes[.font] = FontLayout.font(size: fontSize, weight: weight)
        return TextLayout(attributes: newAttributes)
    }
    
    func change(fontRelativeSize rel: Float, weight: FontWeight) -> TextLayout {
        var newAttributes = attributes
        newAttributes[.font] = FontLayout.font(rel: rel, weight: weight)
        return TextLayout(attributes: newAttributes)
    }
    
    func change(fontRelativeSize rel: Float) -> TextLayout {
        var newAttributes = attributes
        if let oldFont = attributes[.font] as? UIFont, let oldWeight = FontWeight(rawValue: oldFont.fontName) {
            newAttributes[.font] = FontLayout.font(rel: rel, weight: oldWeight)
        }
        return TextLayout(attributes: newAttributes)
    }
    
    func change(foregroundColor: UIColor) -> TextLayout {
        var newAttributes = attributes
        newAttributes[.foregroundColor] = foregroundColor
        return TextLayout(attributes: newAttributes)
    }
    
    func change(backgroundColor: UIColor) -> TextLayout {
        var newAttributes = attributes
        newAttributes[.backgroundColor] = backgroundColor
        return TextLayout(attributes: newAttributes)
    }
    
    func change(underlineColor: UIColor) -> TextLayout {
        var newAttributes = attributes
        newAttributes[.underlineColor] = underlineColor
        return TextLayout(attributes: newAttributes)
    }
    
    func change(textAlignment: NSTextAlignment) -> TextLayout {
        var newAttributes = attributes
        
        if let para = newAttributes[.paragraphStyle] as? NSParagraphStyle,
           let mutable = para.mutableCopy() as? NSMutableParagraphStyle {
            mutable.alignment = textAlignment
            newAttributes[.paragraphStyle] = mutable.copy()
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = textAlignment
        newAttributes[.paragraphStyle] = paragraph
        return TextLayout(attributes: newAttributes)
    }
    
    func change(weight: FontWeight) -> TextLayout {
        let oldFont = font
        let newFont = FontLayout.font(size: oldFont.pointSize, weight: weight)
        var newAttributes = attributes
        newAttributes[.font] = newFont
        return TextLayout(attributes: newAttributes)
    }
}

extension TextLayout {
    @discardableResult
    func apply(to: UILabel?, text: String?) -> TextLayoutCombiner? {
        guard let label = to else { return nil }
        
        label.text = nil
        label.attributedText = nil
        
        var string = String.empty
        if let value = text {
            string = value
        }
        
        // default attributes
        let attributedString = NSAttributedString(string: string, attributes: attributes)

        // assigns att. string
        label.attributedText = attributedString

        // finish
        return TextLayoutCombiner(label: label, attributedString: attributedString)
    }
   
    func apply(to: UITextField?) {
        guard let textfield = to else { return }
        textfield.defaultTextAttributes = attributes.toTypingAttributes()
    }
    
    func apply(to: UITextField?, placeholder: String) {
        guard let textfield = to else { return }
        textfield.defaultTextAttributes = attributes.toTypingAttributes()
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    func apply(to: UITextView?, text: String?) {
        guard let textView = to else { return }
        textView.text = nil
        textView.attributedText = nil
        
        var string = String.empty
        if let value = text {
            string = value
        }
        
        // default attributes
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        // assigns att. string
        textView.attributedText = attributedString
    }
    
    func apply(to: UIButton?, title: String, state: UIControl.State = .normal) {
        guard let button = to else { return }
        
        // default attributes
        let attributedString = NSAttributedString(string: title, attributes: attributes)
    
        button.setAttributedTitle(attributedString, for: state)
        button.titleLabel?.numberOfLines = 0
    }
}
