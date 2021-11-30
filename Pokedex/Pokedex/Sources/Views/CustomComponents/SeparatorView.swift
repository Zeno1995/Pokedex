//
//  SeparatorView.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 28/11/21.
//

import Foundation
import UIKit

class SeparatorView: UIView {

    lazy var separatorView = UIView()

    var margin: Margin? {
        didSet {
            self.setConstraints()
        }
    }

    var separatorColor: UIColor? {
        didSet {
            self.separatorView.backgroundColor = separatorColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(separatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        self.separatorView.removeAllConstraints()
        self.separatorView.anchor(top: self.topAnchor,
                                  left: self.leadingAnchor,
                                  bottom: self.bottomAnchor,
                                  right: self.trailingAnchor,
                                  paddingTop: margin?.top ?? 0,
                                  paddingLeft: margin?.leading ?? 0,
                                  paddingBottom: margin?.bottom ?? 0,
                                  paddingRight: margin?.trailing ?? 0,
                                  height: 1)
    }
}

extension SeparatorView {
    func load(color: UIColor = ColorLayout.separatorGray,
              margin: Margin? = nil) {
        self.margin = margin
        self.separatorColor = color
    }
}
