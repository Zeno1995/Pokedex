//
//  Margin.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 27/11/21.
//

import Foundation
import UIKit

struct Margin {
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat

    public init(top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0) {
        self.top = top
        self.trailing = trailing
        self.bottom = bottom
        self.leading = leading
    }
}
