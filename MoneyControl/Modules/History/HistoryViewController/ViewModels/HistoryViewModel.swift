//
//  HistoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift
import DeepDiff

protocol HistoryViewModelDelegate: class {
    func didReceiveUpdates(insertions: [IndexPath], removals: [IndexPath])
    func didReceiveUpdatesForSections(insertions: IndexSet, removals: IndexSet)
}

class HistoryViewModel {
    
    struct Section {
        let date: Date
        var transactions: [TransactionViewModel] = []
        
        func sum() -> Double {
            return transactions.compactMap {
                if $0.type == .incoming {
                    return $0.value
                } else {
                    return -($0.value)
                }
            }.reduce(0, +)
        }
    }
    
    typealias StatisticsValues = (balance: Double, incomes: Double, outcomes: Double)
    
    // MARK: - Variables
    
    weak var delegate: HistoryViewModelDelegate?
    
    var sections: [Section] = []
    
    let titles = PublishSubject<(String?, String?)>()
    let selectedSort = Variable<Sort>(.day)
    let selectedSortEntity = Variable<SortEntity?>(nil)
    let statisticsValues = PublishSubject<StatisticsValues>()
    
    // MARK: - Variables private
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        selectedSort.asObservable().subscribe(onNext: { [unowned self] _ in
            self.loadTransactions()
        }).disposed(by: disposeBag)
        
        selectedSortEntity.asObservable().subscribe(onNext: { [unowned self] _ in
            self.loadTransactions()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    
    func loadData() {
        loadTransactions()
    }
    
    func loadTransactions() {
        let service = TransactionService.instance
        
        let operateWithTransactions: ([Transaction]) -> Void = { (transactions) in
            
            var sections: [Section] = []
            
            transactions.forEach { transaction in
                if let dateDMY = transaction.time.createDMY() {
                    var tempSection = Section(date: dateDMY)
                    let transactionVM = TransactionViewModel(transaction: transaction)
                    
                    if let index = sections.index(of: tempSection) {
                        sections[index].transactions.append(transactionVM)
                    } else {
                        tempSection.transactions.append(transactionVM)
                        sections.append(tempSection)
                    }
                }
            }
            
            let changes = self.changes(oldSections: self.sections, newSections: sections)
            
            self.sections = sections
            
            self.delegate?.didReceiveUpdatesForSections(insertions: changes.0, removals: changes.1)
            
            self.calculateStatisticsValues()
        }
        
        var fetchEntity: Entity? = nil
        
        if let selectedSortEntity = selectedSortEntity.value {
            switch selectedSortEntity {
            case .wallet(entity: let entity):
                fetchEntity = entity
            default: break
            }
        }

        switch selectedSort.value {
        case .day:
            let dates = Calendar.current.currentDay()
            
            service.fetchTransaction(entity: fetchEntity, dates: dates, type: nil, completion: operateWithTransactions)
            
            let title = dates.start.shortString
            
            titles.onNext((title, nil))
            
        case .week:
            let dates = Calendar.current.currentWeek()
            
            service.fetchTransaction(entity: fetchEntity, dates: dates, type: nil, completion: operateWithTransactions)
            
            let title = dates.start.shortString + " - " + dates.end.shortString
            
            titles.onNext((title, nil))
            
        case .month:
            let dates = Calendar.current.currentMonth()
            
            service.fetchTransaction(entity: fetchEntity, dates: dates, type: nil, completion: operateWithTransactions)

            let title = dates.start.shortString + " - " + dates.end.shortString
            
            titles.onNext((title, nil))
            
        case .year:
            let dates = Calendar.current.currentYear()
            
            service.fetchTransaction(entity: fetchEntity, dates: dates, type: nil, completion: operateWithTransactions)
            
            let title = dates.start.shortString + " - " + dates.end.shortString
            
            titles.onNext((title, nil))
            
        case .custom(from: let fromDate, to: let toDate):
            
            let dates: Calendar.StartEndDate = (fromDate, toDate)
            
            let startOfDay = dates.start.startOfDay
            let endOfDay = dates.end.endOfDay
            
            print("Start ->: \(startOfDay)")
            print("End ->: \(endOfDay))")
            print("-----")
            
            service.fetchTransaction(entity: fetchEntity, dates: (startOfDay, endOfDay), type: nil, completion: operateWithTransactions)
            
            let title = startOfDay.shortString + " - " + endOfDay.shortString
            
            titles.onNext((title, nil))
        }
    }
    
    func removeInnerTransactions(_ viewModel: TransactionViewModel) {
        TransactionService.instance.removeTransactions(viewModel.innerTransactions.map({ $0.id }))
//        transactions.value = transactions.value.filter({ $0.id != viewModel.id })
        calculateStatisticsValues()
    }
    
    func getCurrentSortEntity() -> SortEntity {
        if let selectedSort = selectedSortEntity.value {
            return selectedSort
        } else if let wallet = WalletsService.instance.fetchCurrentWallet() {
            return .wallet(entity: wallet)
        } else {
            return .total
        }
    }
    
    // MARK: - Private methods
    
    private func calculateStatisticsValues() {
        var totalIncomes: Double = 0
        var totalOutcomes: Double = 0
        let totalBalance: Double = TransactionService.instance.fetchBalance(for: nil)
        
//        transactions.value.forEach { (transaction) in
//            if transaction.type == .incoming {
//                totalIncomes += transaction.value
//            } else {
//                totalOutcomes += transaction.value
//            }
//        }
        
        statisticsValues.onNext((totalBalance, totalIncomes, totalOutcomes))
    }
    
    private func changes(oldSections: [Section], newSections: [Section]) -> (IndexSet, IndexSet) {
        
        let changes = diff(old: oldSections, new: newSections)
        
        var inserted: [Int] = []
        var removed: [Int] = []
        
        changes.forEach { change in
            switch change {
            case .insert(let insert):
                inserted.append(insert.index)
            case .delete(let delete):
                removed.append(delete.index)
            default: break
            }
        }

        return (IndexSet(inserted), IndexSet(removed))
    }
}

extension HistoryViewModel.Section: Equatable, DiffAware {
    static func == (lhs: HistoryViewModel.Section, rhs: HistoryViewModel.Section) -> Bool {
        return lhs.date.isDMYEqualTo(date: rhs.date)
    }
    
    var diffId: Date {
        return date
    }
    
    static func compareContent(_ a: HistoryViewModel.Section, _ b: HistoryViewModel.Section) -> Bool {
        return a.date.isDMYEqualTo(date: b.date)
    }
}
