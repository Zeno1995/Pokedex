//
//  StatView.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 27/11/21.
//

import Foundation
import UIKit

class StatView: UIView {
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var statTitleLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return label
    }()
    
    lazy var statProgressView: UIView = {
        let progressView = UIView()
        progressView.backgroundColor = ColorLayout.inactiveBarColor
        return progressView
    }()
    
    lazy var activeStatProgressView: UIView = {
        let progressView = UIView()
        progressView.backgroundColor = ColorLayout.activeBarColor
        return progressView
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return label
    }()
        
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        self.addSubview(self.containerStackView)
        self.containerStackView.anchor(top: self.topAnchor,
                                       left: self.leadingAnchor,
                                       bottom: self.bottomAnchor,
                                       right: self.trailingAnchor,
                                       height: 30)
        
        self.containerStackView.addArrangedSubview(statTitleLabel)
        self.containerStackView.addArrangedSubview(statProgressView)
        self.containerStackView.addArrangedSubview(valueLabel)
        
        self.layoutSubviews()
        
        self.statProgressView.addSubview(self.activeStatProgressView)
        
        self.activeStatProgressView.anchor(top: self.statProgressView.topAnchor,
                                           left: self.statProgressView.leadingAnchor,
                                           bottom: self.statProgressView.bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatView {
    func load(withStatName name: String, andValue value: Int) {
        TextLayout.subtitle.apply(to: self.statTitleLabel, text: name)
        TextLayout.description
            .change(textAlignment: .right)
            .apply(to: self.valueLabel, text: "\(value)")
        self.activeStatProgressView.widthAnchor.constraint(equalTo: statProgressView.widthAnchor, multiplier: CGFloat(value) / 100).isActive = true
    }
}
