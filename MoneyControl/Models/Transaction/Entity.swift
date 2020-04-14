//
//  Entity.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class Entity {
    
    // MARK: - Variables
    
    let title: String
    let currency: Currency
    
    // MARK: - Class methods
    
    class func cashDefault() -> Entity {
        return Entity(title: EntityBaseNamePrefix, currency: settings.currency ?? .usd)
    }
    
    // MARK: - Initializers
    
    init(title: String, currency: Currency) {
        self.title = title
        self.currency = currency
    }
    
    init(db: EntityDB) {
        self.title = db.title
        self.currency = Currency(rawValue: db.currency)
    }
}
