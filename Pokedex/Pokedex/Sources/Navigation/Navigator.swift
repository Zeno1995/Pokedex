//
//  Navigator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

protocol Navigator {            
    func start(nvc: UINavigationController?, coordinator: Coordinator, animated: Bool)
    
    func navigate(to coordinator: Coordinator, animated: Bool)
    
    func present(viewController: UIViewController, presentationStyle: UIModalPresentationStyle)
        
    func back(steps count: Int)
    
    func back()
    
    func dismiss()
    func dismissToRoot(completion: @escaping () -> Void)
    func dismiss(steps count: Int)
    func dismiss(completion: @escaping () -> Void)
}

extension Navigator {
    func dismissToRoot() {
        self.dismissToRoot {}
    }
    
    func present(viewController: UIViewController) {
        present(viewController: viewController, presentationStyle: .fullScreen)
    }
}
