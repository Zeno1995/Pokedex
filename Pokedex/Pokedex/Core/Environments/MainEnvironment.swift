//
//  Messenger.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

extension Environment {
    
    static let mainEnviroment: Environment = {
        return .mainEnviromentProd
    }()
    
    static let mainEnviromentProd: Environment = {
        var header = EnvironmentHeaders()
        header["Content-Type"] = "application/json"
        header["Accept"] = "application/json"
        return Environment(name: "prod", host: "https://pokeapi.co/api/v2", headers: header) 
    }()
}
