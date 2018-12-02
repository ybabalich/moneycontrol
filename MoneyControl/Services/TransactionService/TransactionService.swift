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
    
    // today
    func fetchTodayTransactions(type: Transaction.TransactionType?, completion: ([Transaction]) -> ()) {
        let calendar = Calendar.current
        let (dateFrom, dateTo) = calendar.currentDay()
        fetchTransactions(from: dateFrom, to: dateTo, type: type, completion: completion)
    }
    
    func fetchTodayTransactionsSum(type: Transaction.TransactionType, completion: (Double) -> ()) {
        fetchTodayTransactions(type: type) { (transactions) in
            completion(transactions.map({ $0.value }).reduce(0, +))
        }
    }
    
    // week
    
    /*
     * If send type -> nil - it's means that method will fetch all transactions, ignoring type.
     */
    func fetchWeekTransactions(type: Transaction.TransactionType?, completion: ([Transaction]) -> ()) {
        let calendar = Calendar.current
        let (dateFrom, dateTo) = calendar.currentWeek()
        fetchTransactions(from: dateFrom, to: dateTo, type: type, completion: completion)
    }
    
    
    func save(_ transaction: Transaction) {
        let dbTransaction = TransactionDB()
        dbTransaction.id = Int(Int(Date().timeIntervalSince1970) + Int.random(in: 0...1000000))
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
    
    // removing
    func remove(id: Int) {
        let removePredicate = NSPredicate(format: "id == %d", argumentArray: [id])
        
        let objects = db.objects(TransactionDB.self).filter(removePredicate)
        try! db.write {
            db.delete(objects)
        }
    }
    
    // MARK: - Private methods
    private func fetchTransactions(from date1: Date,
                                   to date2: Date,
                                   type: Transaction.TransactionType?,
                                   completion: ([Transaction]) -> ())
    {
        let predicateFromDate = NSPredicate(format: "time >= %@", argumentArray: [date1])
        let predicateToDate = NSPredicate(format: "time <= %@", argumentArray: [date2])
        var predicateTransactionType: NSPredicate?
        if type != nil {
            predicateTransactionType = NSPredicate(format: "type == %d", type!.rawValue)
        }
        
        var predicates: [NSPredicate] = [predicateFromDate, predicateToDate]

        if predicateTransactionType != nil {
            predicates.append(predicateTransactionType!)
        }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        completion( db.objects(TransactionDB.self).filter(predicate).map({ (transaction) -> Transaction in
            return Transaction(db: transaction)
        }).sorted { $0.time > $1.time } )
    }
    
}
