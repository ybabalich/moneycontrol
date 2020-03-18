//
//  StringExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/17/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import Foundation

extension String {
    
    public var localized: String {
        let service = LocalizationService.instance
        if let value = service.getDictionaryForLanguage(service.preferredLanguage())[self] {
            return value
        }
        return ""
    }
    
    var numeric: Double {
        let replacedString = self.replacingOccurrences(of: ",", with: ".")
        return Double(replacedString) ?? 0.0
    }
    
}
