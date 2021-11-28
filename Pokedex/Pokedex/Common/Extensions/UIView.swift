//
//  UIView.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

//MARK: - Anchors
extension UIView {
    func anchor (top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, safeArea: Bool = false) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var paddingTop = paddingTop
        var paddingBottom = paddingBottom
        
        if #available(iOS 11.0, *), safeArea {
            let window = UIApplication.shared.keyWindow
            paddingTop += window?.safeAreaInsets.top ?? 0
            paddingBottom += window?.safeAreaInsets.bottom ?? 0
        }
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left{
            self.leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right{
            self.trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
    }
    
    //MARK: - Safe area anchors
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
}

extension UIView {
    func removeAllConstraints() {
        var mainSuperview = self.superview

        while let superview = mainSuperview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            mainSuperview = superview.superview
        }

        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
