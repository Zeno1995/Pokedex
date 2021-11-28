//
//  ScrollableStackViewController.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 27/11/21.
//

import Foundation
import UIKit

class ScrollableStackViewController<C>: BaseViewController<C> {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        return scrollView
    }()

    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.clipsToBounds = true
        return stackView
    }()

    var margin: Margin?
    var contentInset: Margin? {
        didSet {
            guard let contentInset = contentInset else {
                scrollView.contentInset = UIEdgeInsets.zero
                return
            }
            scrollView.contentInset = UIEdgeInsets(top: contentInset.top,
                                                   left: contentInset.leading,
                                                   bottom: contentInset.bottom,
                                                   right: contentInset.trailing)
        }
    }
    var bottomConstraint: NSLayoutYAxisAnchor?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.scrollView.anchor(
            top: self.view.safeTopAnchor,
            left: self.view.readableContentGuide.leadingAnchor,
            bottom: self.bottomConstraint ?? self.view.safeBottomAnchor,
            right: self.view.readableContentGuide.trailingAnchor)

        self.scrollView.addSubview(self.containerStackView)
        self.containerStackView.anchor(
            top: self.scrollView.topAnchor,
            left: self.scrollView.leadingAnchor,
            bottom: self.scrollView.bottomAnchor,
            right: self.scrollView.trailingAnchor)

        self.containerStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        let heightAnchor = self.containerStackView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        heightAnchor.priority = UILayoutPriority(rawValue: 250)
        heightAnchor.isActive = true

        self.loadStackView()
    }

    func loadStackView() {

    }
    
    func addSeparatorView() {
        let separatorView = SeparatorView()
        separatorView.load()
        self.containerStackView.addArrangedSubview(separatorView)
    }
}
