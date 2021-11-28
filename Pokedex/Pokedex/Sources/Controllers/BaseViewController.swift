//
//  BaseViewController.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

class BaseViewController<C>: UIViewController, Coordinable {
    let coordinator: C
    var safeHareaTopColor: UIColor? = nil
    var statusBarStyle: UIStatusBarStyle = .default
    
    required init(coordinator: C) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure() {
       
    }
    
//    override open func loadView() {
//        view = UIView(frame: UIScreen.main.bounds)
//        view.backgroundColor = .white
//    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorLayout.bkColor
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if self.navigationController?.isNavigationBarHidden ?? false {
//            if let color = self.safeHareaTopColor {
//                let view = UIView()
//                view.backgroundColor = color
//                self.view.addSubview(view)
//                view.anchor(top: self.view.topAnchor, left: self.view.leadingAnchor, bottom: self.view.safeTopAnchor, right: self.view.trailingAnchor)
//            }
//        }
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if self.navigationController?.isNavigationBarHidden ?? false {
//            return self.statusBarStyle
//        } else {
//            return .default
//        }
//    }
}
