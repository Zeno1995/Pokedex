//
//  StandardNavigator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation
import UIKit

final class StandardNavigator: NSObject {
    private var nvc: UINavigationController?
    private var currentTransition: UIViewControllerAnimatedTransitioning?
    private var lineName: String?
}

// MARK: - Navigator
extension StandardNavigator: Navigator {
    func start(nvc: UINavigationController?, coordinator: Coordinator, animated: Bool = true) {
        self.nvc = nvc
        self.navigate(to: coordinator, animated: true)
    }

    func navigate(to coordinator: Coordinator, animated: Bool = true) {
        go(to: coordinator.start(), animated: animated)
    }
    
    func present(viewController: UIViewController, presentationStyle: UIModalPresentationStyle) {
        viewController.modalPresentationStyle = presentationStyle
        nvc?.present(viewController, animated: true)
    }
    
    func back() {
        self.back(steps: 1)
    }
    
    func back(steps count: Int) {
        if let nvc = self.nvc {
            if nvc.viewControllers.count > count {
                DispatchQueue.main.async {
                    let index = nvc.viewControllers.count - count - 1
                    nvc.popToViewController(nvc.viewControllers[index], animated: true)
                    return
                }
            }
        }
    }
    
    func dismiss() {
        dismiss {}
    }
    
    func dismissToRoot(completion: @escaping () -> Void) {
        dismiss(toRoot: true, completion: completion)
    }
    
    func dismiss(completion: @escaping () -> Void) {
        dismiss(toRoot: false, completion: completion)
    }
    
    func dismiss(steps count: Int) {
        guard let viewController = currentRootViewController else { return }
        if let nvc = viewController as? UINavigationController {
            if nvc.viewControllers.count > count {
                DispatchQueue.main.async {
                    let index = nvc.viewControllers.count - count - 1
                    nvc.popToViewController(nvc.viewControllers[index], animated: true)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.dismissToRoot()
                }
            }
        }
    }
    
    public func dismiss(toRoot: Bool = false, animated: Bool = true, completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.dismiss(toRoot: toRoot, animated: animated, completion: completion)
            }
            return
        }
        
        guard let viewController = currentRootViewController else { return }
        
        // VC sta presentando un figlio
        if viewController.presentedViewController != nil {
            viewController.presentedViewController?.dismiss(animated: animated, completion: completion)
            return
        }
        
        // VC è presentato da un padre
        if viewController.presentingViewController != nil {
            viewController.dismiss(animated: animated, completion: completion)
            return
        }
    }

}

private extension StandardNavigator {
    
    func findFinalPresented(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return findFinalPresented(from: presented)
        }
        
        return viewController
    }
    
    var currentRootViewController: UIViewController? {
        if let nvc = self.nvc {
            return findFinalPresented(from: nvc)
        }
        
        return nil
    }
    
    
    
    func go(to viewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.handleStandard(viewController: viewController, isFullScreen: true, animated: animated)
        }
    }
}

private extension StandardNavigator {
    func handleStandard(viewController: UIViewController, isFullScreen: Bool, animated: Bool = true) {
        if let navController = self.nvc {
            navController.pushViewController(viewController, animated: animated)
        }
    }
    
}
