//
//  VoidCoordiantor.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

class VoidCoordinator<View: Coordinable>: BaseCoordinator<View, Void> {
    init(context: Context) {
        super.init(context: context, param: Void())
    }
}
