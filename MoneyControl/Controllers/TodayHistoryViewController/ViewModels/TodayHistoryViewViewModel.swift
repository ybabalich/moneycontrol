//
//  TodayHistoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/27/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class TodayHistoryViewViewModel {
    
    // MARK: - Variables
    let transactions: PublishSubject<[TransactionViewModel]> = PublishSubject<[TransactionViewModel]>()
    
    // MARK: - Initializers
    init() {
        
    }
    
    // MARK: - Public methods
    func loadData() {
        TransactionService.instance.fetchMyTransactions { [unowned self] (transactions) in
            let transactions = transactions.map({ (transaction) -> TransactionViewModel in
                return TransactionViewModel(transaction: transaction)
            })
            
            self.transactions.onNext(transactions)
        }
    }
    
}
