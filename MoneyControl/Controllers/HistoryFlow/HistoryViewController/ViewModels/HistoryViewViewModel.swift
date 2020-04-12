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
    let titles = PublishSubject<(String?, String?)>()
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
            let dates = Calendar.current.currentDay()
            
            service.fetchTransaction(dates: dates, type: nil, completion: operateWithTransactions)
            
            let title = dates.start.shortString
            
            titles.onNext((title, nil))
            
        case .week:
            let dates = Calendar.current.currentWeek()
            
            service.fetchTransaction(dates: dates, type: nil, completion: operateWithTransactions)
            
            let title = dates.start.shortString + " - " + dates.end.shortString
            
            titles.onNext((title, nil))
            
        case .month:
            let dates = Calendar.current.currentMonth()
            
            service.fetchTransaction(dates: dates, type: nil, completion: operateWithTransactions)

            let title = dates.start.shortString + " - " + dates.end.shortString
            
            titles.onNext((title, nil))
            
        case .year:
            let dates = Calendar.current.currentYear()
            
            service.fetchTransaction(dates: dates, type: nil, completion: operateWithTransactions)
            
            let title = dates.start.shortString + " - " + dates.end.shortString
            
            titles.onNext((title, nil))
            
        case .custom(from: let fromDate, to: let toDate):
            
            let dates: Calendar.StartEndDate = (fromDate, toDate)
            
            let startOfDay = dates.start.startOfDay
            let endOfDay = dates.end.endOfDay
            
            print("Start ->: \(startOfDay)")
            print("End ->: \(endOfDay))")
            print("-----")
            
            service.fetchTransaction(dates: (startOfDay, endOfDay), type: nil, completion: operateWithTransactions)
            
            let title = dates.start.shortString + " - " + dates.end.shortString
            
            titles.onNext((title, nil))
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
