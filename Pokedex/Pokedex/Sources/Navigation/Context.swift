//
//  Navigator.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

struct Context {
    let core: Core
    let navigator: Navigator
    let messenger: Messenger
    
    init(core: Core, navigator: Navigator, messenger: Messenger) {
        self.core = core
        self.messenger = messenger
        self.navigator = navigator
    }
}
