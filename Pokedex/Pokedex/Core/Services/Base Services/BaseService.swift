//
//  BaseService.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

open class BaseService: Service {
    weak var container: Container!
    
    var qualityOfService: QualityOfService = .default
    
    lazy var queue: OperationQueue = {
        let localQueue = OperationQueue()
        localQueue.name = String(describing: self)
        localQueue.qualityOfService = self.qualityOfService
        return localQueue
    }()
    
    init(container: Container) {
        self.container = container
    }
    
    func execute<I, O, E>(_ operation: StandardOperation<I, O, E>, completion: @escaping Completion<O, E>) -> StandardOperation<I, O, E> {
        operation.onCompletion = completion
        queue.addOperation(operation)
        return operation
    }
}

open class ObjectBaseService: NSObject, Service {
    var qualityOfService: QualityOfService = .default
    
    lazy var queue: OperationQueue = {
        let localQueue = OperationQueue()
        localQueue.name = String(describing: self)
        localQueue.qualityOfService = self.qualityOfService
        return localQueue
    }()
    
    func execute<I, O, E>(_ operation: StandardOperation<I, O, E>, completion: @escaping Completion<O, E>) -> StandardOperation<I, O, E> {
        operation.onCompletion = completion
        queue.addOperation(operation)
        return operation
    }
}
