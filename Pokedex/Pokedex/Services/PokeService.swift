//
//  PokeService.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation
import UIKit

protocol PokeService: Service {
    @discardableResult
    func pokemonList(from input: PokemonListRequest,
                     stubFlag: Bool?,
                     completion: @escaping Completion<PokemonListResponse, ServiceError>) -> Operation
    
    @discardableResult
    func pokemonDetail(from input: PokemonDetailRequest,
                     stubFlag: Bool?,
                     completion: @escaping Completion<PokemonDetailResponse, ServiceError>) -> Operation
    
    @discardableResult
    func moveDetail(from input: MoveDetailRequest,
                     stubFlag: Bool?,
                     completion: @escaping Completion<MoveDetailResponse, ServiceError>) -> Operation
    
    @discardableResult
    func downloadImage(input: String, completion: @escaping Completion<UIImage?, ServiceError>) -> Operation
}
