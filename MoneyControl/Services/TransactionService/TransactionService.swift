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
    func fetchTodayTransactions(type: Transaction.TransactionType, completion: ([Transaction]) -> ()) {
        let calendar = Calendar.current
        
        let currentDate = Date()
        let dateFrom = calendar.startOfDay(for: currentDate)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        
        let predicateFromDate = NSPredicate(format: "time >= %@", argumentArray: [dateFrom])
        let predicateToDate = NSPredicate(format: "time <= %@", argumentArray: [dateTo])
        let predicateTransactionType = NSPredicate(format: "type == %d", type.rawValue)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateFromDate, predicateToDate, predicateTransactionType])
        
        completion( db.objects(TransactionDB.self).filter(predicate).map({ (transaction) -> Transaction in
            return Transaction(db: transaction)
        }).sorted { $0.time > $1.time } )
    }
    
    func fetchTodayTransactionsSum(type: Transaction.TransactionType, completion: (Double) -> ()) {
        fetchTodayTransactions(type: type) { (transactions) in
            completion(transactions.map({ $0.value }).reduce(0, +))
        }
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
