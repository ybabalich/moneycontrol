//
//  HistoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class HistoryViewViewModel {
    
    // MARK: - Variables
    let sortCategories = PublishSubject<[HistorySortCategoryViewModel]>()
    let selectedSortCategory = Variable<HistorySortCategoryViewModel>(HistorySortCategoryViewModel(sort: Sort.day))
    let transactions: PublishSubject<[TransactionViewModel]> = PublishSubject<[TransactionViewModel]>()
    
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
            let transactions = transactionsDb.map({ (transaction) -> TransactionViewModel in
                return TransactionViewModel(transaction: transaction)
            })
            
            self.transactions.onNext(transactions)
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
