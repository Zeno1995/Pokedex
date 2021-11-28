//
//  ColorLayout.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

enum ColorLayout {
    static var clear: UIColor                                   = UIColor.clear
    static var white: UIColor                                   = UIColor.white
    static var gray: UIColor                                    = UIColor.gray
    static var black: UIColor                                   = UIColor.black
    
    static var bkColor: UIColor                                 = UIColor.white
    static var primary: UIColor                                 = #colorLiteral(red: 0.8, green: 0, blue: 0, alpha: 1)  // (204, 0, 0)
    static var inactiveBarColor: UIColor                        = #colorLiteral(red: 0.5882353783, green: 0.5882353783, blue: 0.5882353783, alpha: 1)  // (150, 150, 150)
    static var activeBarColor: UIColor                          = #colorLiteral(red: 0.7911849022, green: 0.2906785309, blue: 0, alpha: 1)  // (202, 74, 0)
    
    static var separatorGray: UIColor                           = #colorLiteral(red: 0.7058823529, green: 0.7058823529, blue: 0.7058823529, alpha: 1)  // (180, 180, 180)
}
