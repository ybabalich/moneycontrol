//
//  StringExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/17/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        let service = LocalizationService.instance
        if let value = service.getDictionaryForLanguage(service.preferredLanguage())[self] {
            return value
        }
        return ""
    }
    
}
