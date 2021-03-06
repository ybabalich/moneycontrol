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
    
    //settings
    var currency: Currency? { get set }
    var languageCode: String? { get set }
}

class Settings {
    
    // MARK: - AppSettings
    private struct Keys {
        static let kAppLaunchCount = "kAppLaunchCount"
        static let kBaseCategoriesAdded = "kBaseCategoriesAdded"
        static let kCurrency = "kCurrency"
        static let kPreferredLanguageCodeKey = "kPreferredLanguageCodeKey"
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
    
    var currency: Currency? {
        get {
            if let value = Settings.value(for: Keys.kCurrency) as String? {
                return Currency(stringValue: value)
            }
            return nil
        }
        set {
            if let value = newValue?.stringValue {
                Settings.set(value: value, for: Keys.kCurrency)
            }
        }
    }
    
    var languageCode: String? {
        get {
            return Settings.value(for: Keys.kPreferredLanguageCodeKey)
        }
        set {
            Settings.set(value: newValue, for: Keys.kPreferredLanguageCodeKey)
        }
    }
    
}
