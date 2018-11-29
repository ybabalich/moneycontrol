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
    let selectedTransationType: Variable<Transaction.TransactionType> = Variable<Transaction.TransactionType>(.incoming)
    
    // MARK: - Variables private
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        selectedTransationType.asObservable().subscribe(onNext: { _ in
            self.loadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func loadData() {
        TransactionService.instance.fetchTodayTransactions(type: selectedTransationType.value) { (transactions) in
            let transactions = transactions.map({ (transaction) -> TransactionViewModel in
                return TransactionViewModel(transaction: transaction)
            })
            
            self.transactions.onNext(transactions)
        }
    }
    
}
