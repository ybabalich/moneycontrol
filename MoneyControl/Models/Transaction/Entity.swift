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
    
    let id: Int
    let title: String
    let currency: Currency
    
    // MARK: - Class methods
    
    class func cashDefault() -> Entity {
        return Entity(id: Int.generateID(), title: EntityBaseNamePrefix, currency: settings.currency ?? .usd)
    }
    
    // MARK: - Initializers
    
    init(id: Int, title: String, currency: Currency) {
        self.id = id
        self.title = title
        self.currency = currency
    }
    
    init(db: EntityDB) {
        self.id = db.id
        self.title = db.title
        self.currency = Currency(rawValue: db.currency)
    }
}

extension Entity: Equatable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.id == rhs.id
    }
}
