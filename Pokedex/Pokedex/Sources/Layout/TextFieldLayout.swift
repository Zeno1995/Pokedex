//
//  TextFieldLayout.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

 struct TextFieldLayout {
    let leftImage: UIImage?
    let rightImage: UIImage?
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let keyboardAppearance: UIKeyboardAppearance
    let textAutocapitalizationType: UITextAutocapitalizationType
    let textAutocorrectionType: UITextAutocorrectionType
    let textSpellCheckingType: UITextSpellCheckingType
    let returnKeyType: UIReturnKeyType
    let textLayout: TextLayout
    let clearButtonMode: UITextField.ViewMode
    let borderStyle: UITextField.BorderStyle
    let backgroundImage: UIImage?
    let isLabelHidden: Bool
    
    init(textLayout: TextLayout = .textField,
                leftImage: UIImage? = nil,
                rightImage: UIImage? = nil,
                isSecure: Bool = false,
                keyboardType: UIKeyboardType = .default,
                keyboardAppearance: UIKeyboardAppearance = .default,
                textAutocapitalizationType: UITextAutocapitalizationType = .none,
                textAutocorrectionType: UITextAutocorrectionType = .default,
                textSpellCheckingType: UITextSpellCheckingType = .default,
                returnKeyType: UIReturnKeyType = .default,
                clearButtonMode: UITextField.ViewMode = .whileEditing,
                borderStyle: UITextField.BorderStyle = .roundedRect,
                backgroundImage: UIImage? = nil,
                isLabelHidden: Bool = false) {
        self.textLayout = textLayout
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.keyboardAppearance = keyboardAppearance
        self.textAutocapitalizationType = textAutocapitalizationType
        self.textAutocorrectionType = textAutocorrectionType
        self.textSpellCheckingType = textSpellCheckingType
        self.returnKeyType = returnKeyType
        self.clearButtonMode = clearButtonMode
        self.borderStyle = borderStyle
        self.backgroundImage = backgroundImage
        self.isLabelHidden = isLabelHidden
    }
    
    func apply(to: UITextField?) {
        guard let textField = to else { return }
        
        textField.background = backgroundImage
        
        if let image = leftImage {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .center
            imageView.frame = CGRect(x: 0, y: 0, width: imageView.frame.width + 28, height: imageView.frame.height)
            textField.leftViewMode = .always
            textField.leftView = imageView
        }
        
        textField.isSecureTextEntry = isSecure
        textField.autocorrectionType = textAutocorrectionType
        textField.autocapitalizationType = textAutocapitalizationType
        textField.spellCheckingType = textSpellCheckingType
        textField.returnKeyType = returnKeyType
        textField.keyboardType = keyboardType
        textField.keyboardAppearance = keyboardAppearance
        textField.clearButtonMode = clearButtonMode
        textField.borderStyle = borderStyle
        textField.reloadInputViews()
        
        if #available(iOS 10.0, *) {
            textField.textContentType = nil
        }
        
        textLayout.apply(to: textField)
    }
}
