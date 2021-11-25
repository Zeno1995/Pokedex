//
//  StandardMessenger.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

final class StandardMessenger: Messenger {
    
    lazy var loader: Loader = ProgressLoader()
    lazy var alert: AlertMessage = SystemAlertMessage()
    
    init() {}
}
