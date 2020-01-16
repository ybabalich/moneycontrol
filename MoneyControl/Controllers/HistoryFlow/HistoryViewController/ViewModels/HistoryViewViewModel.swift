//
//  HistoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class HistoryViewViewModel {
    
    typealias StatisticsValues = (balance: Double, incomes: Double, outcomes: Double)
    
    // MARK: - Variables
    let sortCategories = PublishSubject<[HistorySortCategoryViewModel]>()
    let selectedSortCategory = Variable<HistorySortCategoryViewModel>(HistorySortCategoryViewModel(sort: Sort.day))
    let transactions = Variable<[TransactionViewModel]>([])
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
    
    func removeInnerTransactions(_ viewModel: TransactionViewModel) {
        TransactionService.instance.removeTransactions(viewModel.innerTransactions.map({ $0.id }))
        transactions.value = transactions.value.filter({ $0.id != viewModel.id })
        calculateStatisticsValues()
    }
    
    // MARK: - Private methods
    private func getSortCategories() -> [HistorySortCategoryViewModel] {
        let dayCategory = HistorySortCategoryViewModel(sort: .day)
        let weakCategory = HistorySortCategoryViewModel(sort: .week)
        let monthCategory = HistorySortCategoryViewModel(sort: .month)
        return [dayCategory, weakCategory, monthCategory]
    }
    
    private func loadTransactions() {
        
        let service = TransactionService.instance
        
        let handler: ([Transaction]) -> Void = { (transactionsDb) in
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
            
            self.transactions.value = transactions
            self.calculateStatisticsValues()
        }
        
        switch selectedSortCategory.value.sortType {
        case .day:
            service.fetchTodayTransactions(type: nil, completion: handler)
        case .week:
            service.fetchWeekTransactions(type: nil, completion: handler)
        case .month:
            service.fetchMonthTransactions(type: nil, completion: handler)
        default: handler([])
        }
    }
    
    private func calculateStatisticsValues() {
        var totalIncomes: Double = 0
        var totalOutcomes: Double = 0
        var totalBalance: Double = 0
        
        TransactionService.instance.fetchBalanceFromAllTransactions(completion: { [weak self] (currentBalance) in
            guard let strongSelf = self else { return }
            
            totalBalance = currentBalance
            
            strongSelf.transactions.value.forEach { (transaction) in
                if transaction.type == .incoming {
                    totalIncomes += transaction.value
                } else {
                    totalOutcomes += transaction.value
                }
            }
            
            strongSelf.statisticsValues.onNext((totalBalance, totalIncomes, totalOutcomes))
        })
    }
    
}
