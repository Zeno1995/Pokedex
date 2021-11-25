//
//  URLSessionNetwork.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class URLSessionNetwork: BaseService, Network {
    let environment: Environment
    let configuration: URLSessionConfiguration
    private lazy var session: URLSession = URLSession(configuration: self.configuration)

    
    required init(container: Container, environment: Environment, configuration: URLSessionConfiguration = .default) {
        self.environment = environment
        self.configuration = configuration
        
        super.init(container: container)
    }
    
    func perform(request: NetworkRequest, completion: @escaping NetworkCompletion) -> Operation {
        let input = URLSessionOperationInput(request: request, environment: environment, configuration: configuration)
        let op = URLSessionOperation(input: input, container: container)
        op.onCompletion = completion
        queue.addOperation(op)
        return op
    }
}
