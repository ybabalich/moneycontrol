//
//  LocalizationService.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 20.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class LocalizationService {
    
    // MARK: - Singleton
    static let instance = LocalizationService()
    
    // MARK: - Variables static
    static let languagesCodes: [String] = ["en", "uk", "ru"]
    
    // MARK: - Variables public
    
    func preferredLanguage() -> String {
        guard settings.languageCode == nil else { return settings.languageCode! }
        
        //ISO 639-1
        let preferredLanguages = Locale.preferredLanguages
        
        if preferredLanguages.count > 0 {
            for language in preferredLanguages {
                let locale = Locale.init(identifier: language)
                if let languageCode = locale.languageCode {
                    if LocalizationService.languagesCodes.contains(languageCode) {
                        return languageCode
                    }
                }
            }
        }
        
        return "en"
    }
    
    // MARK: - Public methods
    
    func getDictionaryForLanguage(_ languageCode: String) -> [String: String] {
        if let url = Bundle.main.url(forResource: languageCode.lowercased(), withExtension: "strings"),
            let stringsDict = NSDictionary(contentsOf: url) as? [String: String] {
            return stringsDict
        }
        return [:]
    }
    
}

public protocol Localizable {
    
    /// The value that you actually need to have localized.
    var rawValue: String { get }

    /// The name of the `.strings` file to use. Default is `<system language>.strings`.
    var tableName: String { get }

    /// Localized version of `rawValue`.
    var localized: String { get }
}

public extension Localizable {

    var tableName: String { LocalizationService.instance.preferredLanguage() }

    var localized: String {
        return localized(from: tableName)
    }

    private func localized(from tableName: String) -> String {
        return NSLocalizedString(rawValue, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

extension String: Localizable {
    public var rawValue: String { self }
}
