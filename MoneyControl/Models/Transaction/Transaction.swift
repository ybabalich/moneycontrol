//
//  Transaction.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class Transaction {
    
    enum Currency {
        case uah
        case usd
        case rub
    }
    
    enum TransactionType {
        case incoming
        case outcoming
    }
    
    enum Entity {
        case cash
        case card(name: String)
        
        // MARK: - Variables
        var value: String {
            switch self {
            case .cash: return CashDefaultName
            case .card(name: let cardName): return CardDefaultBaseNamePrefix + cardName
            }
        }
    }
    
    // MARK: - Variables
    var id: Int
    var value: Double
    var currency: Currency
    var type: TransactionType
    var category: Category
    var entity: Entity
    var time: Date
    var innerTransactions: [Transaction]?
    
    // MARK: - Initializers
    init() {
        id = 0
        value = 0
        currency = .uah
        type = .incoming
        category = .emptyCategory()
        entity = .cash
        time = Date()
    }
    
    init(db: TransactionDB) {
        self.id = db.id
        self.value = db.value
        self.currency = Currency(rawValue: db.currency)
        self.type = TransactionType(rawValue: db.type)
        self.category = Category.emptyCategory()
        self.entity = .cash
        self.time = db.time
    }
}

extension Transaction.Currency: Rawable {
    
    init(rawValue: Int) {
        switch rawValue {
        case 0: self = .uah
        case 1: self = .usd
        case 2: self = .rub
        default: self = .uah
        }
    }
    
    var rawValue: Int {
        switch self {
        case .uah: return 0
        case .usd: return 1
        case .rub: return 2
        }
    }
    
}

extension Transaction.TransactionType: Rawable {
    
    init(rawValue: Int) {
        switch rawValue {
        case 0: self = .incoming
        case 1: self = .outcoming
        default: self = .incoming
        }
    }
    
    var rawValue: Int {
        switch self {
        case .incoming: return 0
        case .outcoming: return 1
        }
    }
    
}
