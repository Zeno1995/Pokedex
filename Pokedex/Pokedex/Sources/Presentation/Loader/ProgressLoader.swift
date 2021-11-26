//
//  ProgressLoader.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation
import UIKit

final class ProgressLoader {

    let backgroundColor = UIColor.black.withAlphaComponent(0.7)
    let backgroundView = UIView()
    let blurView = UIVisualEffectView()
    var loaderView = UIActivityIndicatorView()

    init() {
        self.loaderView.translatesAutoresizingMaskIntoConstraints = false

        self.loaderView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.loaderView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        self.loaderView.color = ColorLayout.gray

        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.backgroundColor = backgroundColor

        self.blurView.alpha = 0.7
        self.blurView.effect = UIBlurEffect(style: .dark)
        self.blurView.backgroundColor = .clear
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension ProgressLoader: Loader {

    func showLoading() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { self.showLoading() }
            return
        }
        stopLoading()
        guard let window = UIApplication.shared.keyWindow else { return }
        loaderView.startAnimating()

        window.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true

        window.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true

        window.addSubview(loaderView)

        loaderView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
    }

    func stopLoading() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { self.stopLoading() }
            return
        }
        loaderView.stopAnimating()
        loaderView.removeFromSuperview()
        backgroundView.removeFromSuperview()
        blurView.removeFromSuperview()
    }
}
