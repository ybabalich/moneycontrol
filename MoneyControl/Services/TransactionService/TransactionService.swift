//
//  TransactionService.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/27/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class TransactionService: RealmBasedService {
    
    // MARK: - Singleton
    static let instance = TransactionService()
    
    // MARK: - Public methods
    func fetchMyTransactions(completion: ([Transaction]) -> ()) {
        completion( db.objects(TransactionDB.self).map({ (transaction) -> Transaction in
            return Transaction(db: transaction)
        }).sorted { $0.time > $1.time } )
    }
    
    func save(_ transaction: Transaction) {
        let dbTransaction = TransactionDB()
        dbTransaction.value = transaction.value
        dbTransaction.currency = transaction.currency.rawValue
        dbTransaction.type = transaction.type.rawValue
        dbTransaction.time = transaction.time
        
        let category = CategoryDB()
        category.id = transaction.category.id
        category.title = transaction.category.title
        category.imageType = transaction.category.imageRaw
        
        dbTransaction.category = category
        
        try! db.write {
            db.add(dbTransaction)
        }
        
    }
    
}
