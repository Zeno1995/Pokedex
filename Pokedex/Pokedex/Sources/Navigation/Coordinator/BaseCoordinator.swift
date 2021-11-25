//
//  BaseCoordinator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

protocol Coordinable: class {
    associatedtype Coordinator
    init(coordinator: Coordinator)
}

class BaseCoordinator<View: Coordinable, Param>: Coordinator {
    let context: Context
    var param: Param
    
    weak var view: View!
    
    init(context: Context, param: Param) {
        self.context = context
        self.param = param
    }
    
    
    final func start() -> UIViewController {
        let coordinator = self as! View.Coordinator
        let viewController = create(coordinator: coordinator) as! UIViewController
        return viewController
    }
    
    private func create(coordinator: View.Coordinator) -> View {
        let viewController = View(coordinator: coordinator)
        view = viewController
        return viewController
    }
}
