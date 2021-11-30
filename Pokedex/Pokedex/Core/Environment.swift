//
//  Environment.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

typealias EnvironmentHeaders = [String: String]

struct Environment: Codable {
    
    var name: String
    var host: String
    var headers = EnvironmentHeaders()
    
    init(name: String, host: String) {
        self.init(name: name, host: host, headers: [:])
    }
    
    init(name: String, host: String, headers: EnvironmentHeaders) {
        self.name = name
        self.host = host
        self.headers = headers
    }
}
