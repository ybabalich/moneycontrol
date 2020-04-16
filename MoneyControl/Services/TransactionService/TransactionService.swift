//
//  TransactionService.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/27/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class TransactionService {
    
    // MARK: - Singleton
    static let instance = TransactionService()
    
    // MARK: - Public methods
    
    /// Fetch balance for entitites
    /// - Parameters:
    ///   - entity: Entity for which need fetch balance, nil means that need to fetch for all entities
    /// - Returns: Total balance
    func fetchBalance(for entity: Entity?) -> Double {
        var currentBalance: Double = 0.0
        
        if let entity = entity {
            db.objects(TransactionDB.self).filter("entity.title == %@", entity.title).forEach { (transactionDb) in
                let value = transactionDb.value
                currentBalance += (transactionDb.type == Transaction.TransactionType.incoming.rawValue) ? value : -(value)
            }
        } else {
            db.objects(TransactionDB.self).forEach { (transactionDb) in
                let value = transactionDb.value
                currentBalance += (transactionDb.type == Transaction.TransactionType.incoming.rawValue) ? value : -(value)
            }
        }

        return currentBalance
    }
    
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
    
    //  month
    func fetchMonthTransactions(type: Transaction.TransactionType?, completion: ([Transaction]) -> ()) {
        let calendar = Calendar.current
        let (dateFrom, dateTo) = calendar.currentMonth()
        fetchTransactions(from: dateFrom, to: dateTo, type: type, completion: completion)
    }
    
    func fetchTransaction(entity: Entity? = nil,
                          dates: Calendar.StartEndDate,
                          type: Transaction.TransactionType?,
                          completion: ([Transaction]) -> ()) {
        
        fetchTransactions(entity: entity, from: dates.start, to: dates.end, type: type, completion: completion)
    }
    
    // MARK: - Saving/Updating
    
    func save(_ transaction: Transaction) {
        let dbTransaction = TransactionDB()
        dbTransaction.id = Int(Int(Date().timeIntervalSince1970) + Int.random(in: 0...1000000))
        dbTransaction.value = transaction.value
        
        var entityDB: EntityDB?
        
        if let entity = db.objects(EntityDB.self).filter(NSPredicate(format: "title == %@", transaction.entity.title)).first {
            entityDB = entity
        } else {
            let dbEntity = EntityDB()
            dbEntity.currency = transaction.entity.currency.rawValue
            dbEntity.title = transaction.entity.title
            entityDB = dbEntity
        }
        
        dbTransaction.entity = entityDB
        dbTransaction.type = transaction.type.rawValue
        dbTransaction.time = transaction.time
        
        dbTransaction.categoryId = transaction.category.id
        
        try! db.write {
            db.add(dbTransaction)
        }
        
    }
    
    func update(_ transaction: Transaction) {
        let fetchPredicate = NSPredicate(format: "id == %d", argumentArray: [transaction.id])
        
        let objects = db.objects(TransactionDB.self).filter(fetchPredicate)
        
        if let transactionDb = objects.first {
            try! db.write {
                transactionDb.categoryId = transaction.category.id
                transactionDb.value = transaction.value
                transactionDb.time = transaction.time
            }
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
    
    //sorting
    func sortedByGroups(transactions: [Transaction], completion: ([TransactionViewModel]) -> Void) {
        let handler: ([Transaction]) -> [TransactionViewModel] = { (transactionsDb) in
            var transactions: [TransactionViewModel] = []
            
            // all transactions grouped by transaction types Incoming/Outcoming (2 keys)
            let groupedTransactionsByType = Dictionary(grouping: transactionsDb, by: { (transaction) -> Transaction.TransactionType in
                return transaction.type
            })
            
            // each transactions in values grouped by category id
            
            //incoming
            var incomesGroupedByCategory: [Category: [Transaction]] = [:]
            if let incomesValues = groupedTransactionsByType[Transaction.TransactionType.incoming] {
                incomesGroupedByCategory = Dictionary(grouping: incomesValues, by: { (transaction) -> Category in
                    return transaction.category
                })
            }
            
            //outcoming
            var outcomesGroupedByCategory: [Category: [Transaction]] = [:]
            if let outcomesValues = groupedTransactionsByType[Transaction.TransactionType.outcoming] {
                outcomesGroupedByCategory = Dictionary(grouping: outcomesValues, by: { (transaction) -> Category in
                    return transaction.category
                })
            }
            
            incomesGroupedByCategory.keys.forEach({ (category) in
                let transaction = Transaction()
                transaction.id = Int(Int(Date().timeIntervalSince1970) + Int.random(in: 0...1000000))
                transaction.value = incomesGroupedByCategory[category]!.map({ $0.value }).reduce(0, +)
                transaction.type = .incoming
                transaction.category = category
                transaction.time = Date()
                transaction.innerTransactions = incomesGroupedByCategory[category]
                
                transactions.append(TransactionViewModel(transaction: transaction))
            })
            
            outcomesGroupedByCategory.keys.forEach({ (category) in
                let transaction = Transaction()
                transaction.id = Int(Int(Date().timeIntervalSince1970) + Int.random(in: 0...1000000))
                transaction.value = outcomesGroupedByCategory[category]!.map({ $0.value }).reduce(0, +)
                transaction.type = .outcoming
                transaction.category = category
                transaction.time = Date()
                transaction.innerTransactions = outcomesGroupedByCategory[category]
                
                transactions.append(TransactionViewModel(transaction: transaction))
            })
            
            return transactions
        }
        
        completion(handler(transactions))
    }
    
    // MARK: - Private methods
    private func fetchTransactions(entity: Entity? = nil,
                                   from date1: Date,
                                   to date2: Date,
                                   type: Transaction.TransactionType?,
                                   completion: ([Transaction]) -> ())
    {
        let predicateFromDate = NSPredicate(format: "time >= %@", argumentArray: [date1])
        let predicateToDate = NSPredicate(format: "time <= %@", argumentArray: [date2])
        
        var predicates: [NSPredicate] = [predicateFromDate, predicateToDate]
        
        if type != nil {
            predicates.append(NSPredicate(format: "type == %d", type!.rawValue))
        }
        
        if entity != nil {
            predicates.append(NSPredicate(format: "entity.title == %@", entity!.title.lowercased()))
        }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        completion( db.objects(TransactionDB.self).filter(predicate).map({ (transactionDb) -> Transaction in
            let transaction = Transaction(db: transactionDb)
            let categoryPredicate = NSPredicate(format: "id == %d", argumentArray: [transactionDb.categoryId])
            let categoryDb = db.objects(CategoryDB.self).filter(categoryPredicate)[0]
            transaction.category = Category(db: categoryDb)
            return transaction
        }).sorted { $0.time > $1.time } )
    }
}
