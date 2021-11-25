//
//  SystemAlertMessage.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

final class SystemAlertMessage {
    private func alert(title: String,
                       description: String? = nil,
                       cancelButtonTitle: String? = nil,
                       confirmButtonTitle: String? = nil,
                       completion: ((AlertResponse) -> Void)? = nil) {

        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.alert(title: title,
                           description: description,
                           cancelButtonTitle: cancelButtonTitle,
                           confirmButtonTitle: confirmButtonTitle,
                           completion: completion)
            }
            return
        }
        
        let alert = UIAlertController(title: title,
                                      message: description ?? String.empty,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: confirmButtonTitle ?? "OK", style: .default) { _ in
            completion?(.confirm)
        }
        alert.addAction(action)
        
        if let dismissTitle = cancelButtonTitle {
            let action = UIAlertAction(title: dismissTitle, style: .default) { _ in
                completion?(.cancel)
            }
            alert.addAction(action)
        }
        UIApplication.shared.keyWindow?.rootViewController?.lastViewController?.present(alert, animated: true)
    }
}

extension SystemAlertMessage: AlertMessage {
    func showAlert(title: String) {
        self.alert(title: title)
    }

    func showAlert(title: String, description: String) {
        self.alert(title: title, description: description)
    }
}
