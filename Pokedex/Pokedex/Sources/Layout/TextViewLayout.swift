//
//  TextViewLayout.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

struct TextViewLayout {
   let keyboardType: UIKeyboardType
   let keyboardAppearance: UIKeyboardAppearance
   let textAutocapitalizationType: UITextAutocapitalizationType
   let textAutocorrectionType: UITextAutocorrectionType
   let textSpellCheckingType: UITextSpellCheckingType
   let returnKeyType: UIReturnKeyType
   let textLayout: TextLayout
   let isLabelHidden: Bool
   
   init(textLayout: TextLayout = .textField,
               keyboardType: UIKeyboardType = .default,
               keyboardAppearance: UIKeyboardAppearance = .default,
               textAutocapitalizationType: UITextAutocapitalizationType = .none,
               textAutocorrectionType: UITextAutocorrectionType = .default,
               textSpellCheckingType: UITextSpellCheckingType = .default,
               returnKeyType: UIReturnKeyType = .default,
               isLabelHidden: Bool = false) {
       self.textLayout = textLayout
       self.keyboardType = keyboardType
       self.keyboardAppearance = keyboardAppearance
       self.textAutocapitalizationType = textAutocapitalizationType
       self.textAutocorrectionType = textAutocorrectionType
       self.textSpellCheckingType = textSpellCheckingType
       self.returnKeyType = returnKeyType
       self.isLabelHidden = isLabelHidden
   }
   
    func apply(to: UITextView?, text: String) {
       guard let textView = to else { return }
       
    textView.autocorrectionType = textAutocorrectionType
    textView.autocapitalizationType = textAutocapitalizationType
    textView.spellCheckingType = textSpellCheckingType
    textView.returnKeyType = returnKeyType
    textView.keyboardType = keyboardType
    textView.keyboardAppearance = keyboardAppearance
    textView.reloadInputViews()
       
       if #available(iOS 10.0, *) {
        textView.textContentType = nil
       }
       
    textLayout.apply(to: textView, text: text)
   }
}
