//
//  HistoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class HistoryViewViewModel {
    
    typealias StatisticsValues = (incomes: Double, outcomes: Double)
    
    // MARK: - Variables
    let sortCategories = PublishSubject<[HistorySortCategoryViewModel]>()
    let selectedSortCategory = Variable<HistorySortCategoryViewModel>(HistorySortCategoryViewModel(sort: Sort.day))
    let transactions: PublishSubject<[TransactionViewModel]> = PublishSubject<[TransactionViewModel]>()
    let statisticsValues = PublishSubject<StatisticsValues>()
    
    // MARK: - Variables private
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        selectedSortCategory.asObservable().subscribe(onNext: { [unowned self] _ in
            self.loadTransactions()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func loadData() {
        sortCategories.onNext(getSortCategories())
        loadTransactions()
    }
    
    // MARK: - Private methods
    private func getSortCategories() -> [HistorySortCategoryViewModel] {
        let dayCategory = HistorySortCategoryViewModel(sort: Sort.day)
        let weakCategory = HistorySortCategoryViewModel(sort: Sort.week)
        let monthCategory = HistorySortCategoryViewModel(sort: Sort.month)
        return [dayCategory, weakCategory, monthCategory]
    }
    
    private func loadTransactions() {
        
        let handler: ([Transaction]) -> Void = { (transactionsDb) in
            var transactions: [TransactionViewModel] = []
            var totalIncomes: Double = 0
            var totalOutcomes: Double = 0
            
            // all transactions grouped by transaction types Incoming/Outcoming (2 keys)
            let groupedTransactionsByType = Dictionary(grouping: transactionsDb, by: { (transaction) -> Transaction.TransactionType in
                return transaction.type
            })
            
            // each transactions in values grouped by category id
            
            //incoming
            var incomesGroupedByCategory: [Category: [Transaction]] = [:]
            if let incomesValues = groupedTransactionsByType[Transaction.TransactionType.incoming] {
                totalIncomes = incomesValues.map({ $0.value }).reduce(0, +)
                
                incomesGroupedByCategory = Dictionary(grouping: incomesValues, by: { (transaction) -> Category in
                    return transaction.category
                })
            }
            
            //outcoming
            var outcomesGroupedByCategory: [Category: [Transaction]] = [:]
            if let outcomesValues = groupedTransactionsByType[Transaction.TransactionType.outcoming] {
                totalOutcomes = outcomesValues.map({ $0.value }).reduce(0, +)
                
                outcomesGroupedByCategory = Dictionary(grouping: outcomesValues, by: { (transaction) -> Category in
                    return transaction.category
                })
            }
            
            incomesGroupedByCategory.keys.forEach({ (category) in
                let transaction = Transaction()
                transaction.value = incomesGroupedByCategory[category]!.map({ $0.value }).reduce(0, +)
                transaction.type = .incoming
                transaction.category = category
                transaction.time = Date()
                
                transactions.append(TransactionViewModel(transaction: transaction))
            })
            
            outcomesGroupedByCategory.keys.forEach({ (category) in
                let transaction = Transaction()
                transaction.value = outcomesGroupedByCategory[category]!.map({ $0.value }).reduce(0, +)
                transaction.type = .outcoming
                transaction.category = category
                transaction.time = Date()
                
                transactions.append(TransactionViewModel(transaction: transaction))
            })

            self.transactions.onNext(transactions)
            self.statisticsValues.onNext((totalIncomes, totalOutcomes))
        }
        
        let service = TransactionService.instance
        
        switch selectedSortCategory.value.sortType {
        case .day:
            service.fetchTodayTransactions(type: nil, completion: handler)
        case .week:
            service.fetchWeekTransactions(type: nil, completion: handler)
        default: handler([])
        }
    }
    
}
