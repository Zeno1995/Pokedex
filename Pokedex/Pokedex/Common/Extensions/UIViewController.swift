//
//  UIViewController.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

extension UIViewController {
    var lastViewController: UIViewController? {
        if let nvc = self as? UINavigationController {
            return nvc.visibleViewController
        }

        if let pvc = self.presentedViewController {
            return pvc
        }

        return self
    }
}
