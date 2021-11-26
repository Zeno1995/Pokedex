//
//  SessionService.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

protocol SessionService: Service {
    func networkCache() -> NetworkCache
    func imageCache() -> ImageCache
}
