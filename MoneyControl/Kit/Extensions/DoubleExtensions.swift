//
//  DoubleExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 23.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

extension Double {
    
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.locale = Locale.current
        return formatter.string(for: self)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
    var currencyFormattedWithSymbol: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let currency = settings.currency {
            formatter.currencySymbol = currency.symbol
        }
        
        formatter.locale = Locale.current
        return formatter.string(for: self)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
}
