//
//  Entity+DB.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

extension Entity {
    
    var isActive: Bool {
        return settings.wallet?.lowercased() == title.lowercased()
    }
    
    var balance: Double {
        return TransactionService.instance.fetchBalance(for: self)
    }
    
}
