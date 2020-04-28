//
//  Transaction.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class Transaction {
    
    enum TransactionType {
        case incoming
        case outcoming
    }
    
    // MARK: - Variables
    var id: Int
    var value: Double
    var type: TransactionType
    var category: Category
    var entity: Entity
    var time: Date
    var innerTransactions: [Transaction]?
    
    // MARK: - Initializers
    init() {
        id = 0
        value = 0
        type = .incoming
        category = .emptyCategory()
        entity = .cashDefault()
        time = Date()
    }
    
    init(db: TransactionDB) {
        self.id = db.id
        self.value = db.value
        self.type = TransactionType(rawValue: db.type)
        self.category = Category(id: db.categoryId)
        
        if let dbEntity = db.entity {
            self.entity = Entity(db: dbEntity)
        } else {
            self.entity = .cashDefault()
        }
        
        self.time = db.time
    }
    
    init(viewModel: TransactionViewModel) {
        self.id = viewModel.id
        self.value = viewModel.value
        self.type = viewModel.type
        self.category = Category(viewModel: viewModel.category)
        self.entity = viewModel.entity
        self.time = viewModel.createdTime
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
    
    var localizedTitle: String {
        switch self {
        case .incoming: return "Revenues".localized
        case .outcoming: return "Spendings".localized
        }
    }
    
}
