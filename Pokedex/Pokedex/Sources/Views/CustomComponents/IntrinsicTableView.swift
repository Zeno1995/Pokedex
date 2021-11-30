//
//  IntrinsicTableView.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 29/11/21.
//

import Foundation
import UIKit

final class IntrinsicTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}
