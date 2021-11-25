//
//  Container.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

enum ContainerError: Swift.Error {
    case componentNotFound
    case cantCreateComponent
}

protocol Container: AnyObject {
    typealias Factory<T> = (Container) throws -> T
    
    func register<T>(key: String, instance: T)
    func register<T>(key: String, factory: @escaping Factory<T>)
    
    func register<T>(type: T.Type, instance: T)
    func register<T>(type: T.Type, factory: @escaping Factory<T>)
    
    func resolve<T>() throws -> T
    func resolve<T>(key: String) throws -> T
}
