//
//  UserDefaultsExtensions.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import UIKit

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
