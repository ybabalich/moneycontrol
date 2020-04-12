//
//  TransactionsHistoryListViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 19.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import RxSwift

class TransactionsHistoryListViewModel {
        
    // MARK: - Variables public
    var historyViewModel: HistoryViewModel? = nil
    let transactions = Variable<[TransactionViewModel]>([])
    
    // MARK: - Public methods
    func loadData() {
        guard let historyViewModel = historyViewModel else { return }
        
        let service = TransactionService.instance
        
        func makeSorted(_ transactions: [Transaction]) {
            service.sortedByGroups(transactions: transactions) { [weak self] (transactionsVM) in
                guard let strongSelf = self else { return }
                
                if let transaction = transactionsVM.first(where: { $0.category.id == historyViewModel.category.id }) {
                    strongSelf.transactions.value = transaction.innerTransactions
                } else {
                    strongSelf.transactions.value = []
                }
            }
        }
        
        switch historyViewModel.sortCategory.sortType {
        case .day:
            service.fetchTodayTransactions(type: nil) {  (transactions) in
                let transactions = transactions.filter { $0.category.id == historyViewModel.category.id }
                
                makeSorted(transactions)
            }
        case .month:
            service.fetchMonthTransactions(type: nil) {  (transactions) in
                let transactions = transactions.filter { $0.category.id == historyViewModel.category.id }
                
                makeSorted(transactions)
            }
        case .week:
            service.fetchMonthTransactions(type: nil) {  (transactions) in
                let transactions = transactions.filter { $0.category.id == historyViewModel.category.id }
                
                makeSorted(transactions)
            }
        case .year:
            let calendarYear = Calendar.current.currentYear()
            service.fetchTransaction(dates: calendarYear, type: nil) { transactions in
                let transactions = transactions.filter { $0.category.id == historyViewModel.category.id }
                
                makeSorted(transactions)
            }
        case .custom(from: let fromDate, to: let toDate):
            service.fetchTransaction(dates: (fromDate, toDate), type: nil) { transactions in
                let transactions = transactions.filter { $0.category.id == historyViewModel.category.id }
                
                makeSorted(transactions)
            }
        }
    }
    
}
