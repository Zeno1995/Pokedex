//
//  ButtonLayout.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

struct ButtonLayout {
    let image: UIImage?
    let backgroundImage: UIImage?
    let backgroundColor: UIColor
    let backgroundImageSelected: UIImage?
    let titleLayout: TextLayout
    let borderColor: UIColor
    let borderSize: Float
    let cornerRadius: Float
    let alwaysOriginalRendering: Bool
    let defaultCornerRadius: Bool
    let underlineColor: ColorLayout?
    let buttonLayoutType: UIButton.ButtonLayoutType
    
    init(titleLayout: TextLayout = .buttonFull,
                backgroundColor: UIColor = ColorLayout.clear,
                backgroundImage: UIImage? = nil,
                backgroundImageSelected: UIImage? = nil,
                image: UIImage? = nil,
                alwaysOriginalRendering: Bool = true,
                borderColor: UIColor = ColorLayout.clear,
                borderSize: Float = 0.0,
                cornerRadius: Float = 0.0,
                defaultCornerRadius: Bool = false,
                underlineColor: ColorLayout? = nil,
                buttonLayoutType: UIButton.ButtonLayoutType = .full) {
        
        self.titleLayout = titleLayout
        self.backgroundImage = backgroundImage
        self.backgroundColor = backgroundColor
        self.backgroundImageSelected = backgroundImageSelected
        self.image = image
        self.borderColor = borderColor
        self.borderSize = borderSize
        self.cornerRadius = cornerRadius
        self.alwaysOriginalRendering = alwaysOriginalRendering
        self.defaultCornerRadius = defaultCornerRadius
        self.buttonLayoutType = buttonLayoutType
        self.underlineColor = underlineColor
    }
    
    func apply(to: UIButton?, title: String) {
        apply(to: to, title: title, titleEdgeInsets: to?.titleEdgeInsets ?? .zero)
    }
    
    func apply(to: UIButton?, title: String, titleEdgeInsets: UIEdgeInsets) {
        guard let button = to else { return }
        
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.setBackgroundImage(backgroundImageSelected, for: .selected)
        button.setBackgroundImage(backgroundImageSelected, for: .highlighted)
        button.backgroundColor = backgroundColor
        
        if let currentImage = image?.withRenderingMode(alwaysOriginalRendering ? .alwaysOriginal: .alwaysTemplate) {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
            button.setImage(currentImage, for: .normal)
        }
        
        if cornerRadius != 0.0 {
            button.layer.cornerRadius = CGFloat(cornerRadius)
        }
        
        if defaultCornerRadius == true {
            button.layer.cornerRadius = button.bounds.height / 2.0
        }
        
        if borderSize > 0.0, borderColor != ColorLayout.clear {
            button.layer.borderWidth = CGFloat(borderSize)
            button.layer.borderColor = borderColor.cgColor
        }
        
        titleLayout.apply(to: button, title: title)
    }
}
