//
//  Core.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

open class Core {
    
    let environment: Environment
    let container: Container
    
    //Services    
    lazy var sessionService: SessionService = SessionServiceCore(container: container)
    
    init(container: Container, environment: Environment) {
        self.container = container
        self.environment = environment
        
        self.setupContainer()
    }
}

extension Core {
    func setupContainer() {
        container.register(type: Environment.self, instance: environment)
        container.register(type: Network.self, instance: URLSessionNetwork(container: container, environment: environment))
        container.register(type: SessionService.self, instance: sessionService)
    }
}
