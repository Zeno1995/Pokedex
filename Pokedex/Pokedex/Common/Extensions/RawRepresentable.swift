//
//  RawRepresentable.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 24/11/21.
//

import Foundation

extension RawRepresentable where RawValue == String, Self: Localizable {
    var localized: String {
        let key = "\(localizedKey).\(String(describing: type(of: self)).lowercased()).\(self)"
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.main, value: String.empty, comment: String.empty)
    }
    
    func localized(args: CVarArg...) -> String {
        let key = "\(localizedKey).\(String(describing: type(of: self)).lowercased()).\(self)"
        let text = NSLocalizedString(key, tableName: nil, bundle: Bundle.main, value: String.empty, comment: String.empty) as NSString
        return String(format: text as String, arguments: args)
    }
}
