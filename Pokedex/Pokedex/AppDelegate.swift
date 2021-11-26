//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let container: Container = ComponentContainer()
    let navigator: Navigator = StandardNavigator()
    let messenger: Messenger = StandardMessenger()

    lazy var core = Core(container: container, environment: .mainEnviroment)
    private lazy var context = Context(core: self.core, navigator: navigator, messenger: messenger)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navVC = UINavigationController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVC
        context.navigator.start(nvc: navVC, coordinator: PokemonListCoordinator(context: context), animated: true)

        self.window?.makeKeyAndVisible()
        
        return true
    }

}

