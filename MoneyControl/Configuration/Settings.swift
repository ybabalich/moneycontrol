//
//  Settings.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/3/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

protocol AppSettings {
    //general
    var launchCount: Int { get set }
    var baseCategoriesAdded: Bool { get set }
}

class Settings {
    
    // MARK: - AppSettings
    private struct Keys {
        static let kAppLaunchCount = "kAppLaunchCount"
        static let kBaseCategoriesAdded = "kBaseCategoriesAdded"
    }
    
    // MARK: - Private methods
    fileprivate static func set(value: Any?, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    fileprivate static func value<T>(for key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
}

extension Settings: AppSettings {
    
    var launchCount: Int {
        get {
            return Settings.value(for: Keys.kAppLaunchCount) ?? 0
        }
        set {
            Settings.set(value: newValue, for: Keys.kAppLaunchCount)
        }
    }
    
    var baseCategoriesAdded: Bool {
        get {
            return Settings.value(for: Keys.kBaseCategoriesAdded) ?? false
        }
        set {
            Settings.set(value: newValue, for: Keys.kBaseCategoriesAdded)
        }
    }
    
}
