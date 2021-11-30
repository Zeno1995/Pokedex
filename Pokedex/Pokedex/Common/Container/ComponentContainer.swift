//
//  ComponentContainer.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class ComponentContainer {
    private var components: [String: Any] = [:]
    
    init() {}
}

private extension ComponentContainer {
    func internalResolve<T>(for key: String) throws -> T {
        guard let component = components[key] else {
            throw ContainerError.componentNotFound
        }
        
        if let factory = component as? Factory<T> {
            return try factory(self)
        }
        
        guard let result = component as? T else {
            throw ContainerError.cantCreateComponent
        }
        
        return result
    }
}

extension ComponentContainer: Container {
    func register<T>(type: T.Type, instance: T) {
        register(key: "\(type)", instance: instance)
    }
    
    func register<T>(type: T.Type, factory: @escaping Factory<T>) {
        components["\(type)"] = factory
    }
    
    func register<T>(key: String, instance: T) {
        components[key] = instance
    }
    
    func register<T>(key: String, factory: @escaping (Container) throws -> T) {
        components[key] = factory
    }
    
    func resolve<T>() throws -> T {
        return try resolve(key: "\(T.self)")
    }
    
    func resolve<T>(key: String) throws -> T {
        return try internalResolve(for: key)
    }
}
