//
//  TextLayoutCombiner.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

struct TextLayoutCombiner {
    private let label: UILabel
    private let attributedString: NSAttributedString
    
    internal init(label: UILabel, attributedString: NSAttributedString) {
        self.label = label
        self.attributedString = attributedString
    }
    
    func change(layout: TextLayout, for text: String) {
        if let range = attributedString.string.range(of: text) {
            let mutable = NSMutableAttributedString(attributedString: attributedString)
            let nsrange = NSRange(range, in: attributedString.string)
            mutable.addAttributes(layout.attributes, range: nsrange)
            label.attributedText = mutable
        }
    }
    
    @discardableResult
    func append(text: String, with layout: TextLayout) -> TextLayoutCombiner {
        let mutable = NSMutableAttributedString(attributedString: attributedString)
        let appendAttributedString = NSAttributedString(string: text, attributes: layout.attributes)
        mutable.append(appendAttributedString)
        label.attributedText = mutable
        
        return TextLayoutCombiner(label: label, attributedString: mutable)
    }
    
    @discardableResult
    func append(attributedText: NSMutableAttributedString, with layout: TextLayout) -> TextLayoutCombiner {
        let mutable = NSMutableAttributedString(attributedString: attributedString)
        attributedText.addAttributes(layout.attributes, range: NSRange(location: 0, length: attributedText.length))
        mutable.append(attributedText)
        label.attributedText = mutable
        
        return TextLayoutCombiner(label: label, attributedString: mutable)
    }
}
