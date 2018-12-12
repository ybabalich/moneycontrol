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
    func fetchBalanceFromAllTransactions(completion: (Double) -> ()) {
        var currentBalance: Double = 0.0
        
        db.objects(TransactionDB.self).forEach { (transactionDb) in
            let value = transactionDb.value
            currentBalance += (transactionDb.type == Transaction.TransactionType.incoming.rawValue) ? value : -(value)
        }
        
        completion(currentBalance)
    }
    
    // today
    func fetchTodayTransactions(type: Transaction.TransactionType?, completion: ([Transaction]) -> ()) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
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
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let (dateFrom, dateTo) = calendar.currentWeek()
        fetchTransactions(from: dateFrom, to: dateTo, type: type, completion: completion)
    }
    
    //  month
    func fetchMonthTransactions(type: Transaction.TransactionType?, completion: ([Transaction]) -> ()) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let (dateFrom, dateTo) = calendar.currentMonth()
        fetchTransactions(from: dateFrom, to: dateTo, type: type, completion: completion)
    }
    
    // MARK: - Saving
    
    func save(_ transaction: Transaction) {
        let dbTransaction = TransactionDB()
        dbTransaction.id = Int(Int(Date().timeIntervalSince1970) + Int.random(in: 0...1000000))
        dbTransaction.value = transaction.value
        dbTransaction.currency = transaction.currency.rawValue
        dbTransaction.type = transaction.type.rawValue
        dbTransaction.time = transaction.time
        
        dbTransaction.categoryId = transaction.category.id
        
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
    
    func removeTransactions(_ ids: [Int]) {
        guard ids.count > 0 else { return }

        let arrayPredicate = NSPredicate(format: "id IN %@", argumentArray: [ids])
        
        let objects = db.objects(TransactionDB.self).filter(arrayPredicate)
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
        
        completion( db.objects(TransactionDB.self).filter(predicate).map({ (transactionDb) -> Transaction in
            let transaction = Transaction(db: transactionDb)
            let categoryPredicate = NSPredicate(format: "id == %d", argumentArray: [transactionDb.categoryId])
            let categoryDb = self.db.objects(CategoryDB.self).filter(categoryPredicate)[0]
            transaction.category = Category(db: categoryDb)
            return transaction
        }).sorted { $0.time > $1.time } )
    }
    
}
