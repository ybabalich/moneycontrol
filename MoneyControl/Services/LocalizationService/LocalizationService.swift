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
    
    
    // MARK: - Public methods
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
    
    func getDictionaryForLanguage(_ languageCode: String) -> [String: String] {
        if let url = Bundle.main.url(forResource: languageCode.lowercased(), withExtension: "strings"),
            let stringsDict = NSDictionary(contentsOf: url) as? [String: String] {
            return stringsDict
        }
        return [:]
    }
    
}
