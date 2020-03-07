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
    
    func loadTransactions() {
        let service = TransactionService.instance
        
        let operateWithTransactions: ([Transaction]) -> Void = { (transactions) in
            service.sortedByGroups(transactions: transactions) { (transactionsViewModels) in
                self.transactions.value = transactionsViewModels
                self.calculateStatisticsValues()
            }
        }
        
        switch selectedSortCategory.value.sortType {
        case .day:
            service.fetchTodayTransactions(type: nil, completion: operateWithTransactions)
        case .week:
            service.fetchWeekTransactions(type: nil, completion: operateWithTransactions)
        case .month:
            service.fetchMonthTransactions(type: nil, completion: operateWithTransactions)
        default: operateWithTransactions([])
        }
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
