//
//  Messenger.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

protocol Messenger {
    var alert: AlertMessage { get }
    var loader: Loader { get }
}

protocol Loader {
    func showLoading()
    func stopLoading()
}

protocol AlertMessage {
    func showAlert(title: String)

    func showAlert(title: String, description: String)
}
