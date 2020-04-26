//
//  HistoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation
import DeepDiff

protocol HistoryViewModelDelegate: class {
    func didReceiveUpdates(insertions: [IndexPath], removals: [IndexPath], updates: [IndexPath])
    func didReceiveUpdatesForSections(insertions: IndexSet, removals: IndexSet)
    func didCalculate(incomes: Double, outcomes: Double)
    func didChooseDate(title: String)
    func didSelectSort(selectedSort: Sort)
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
    
    // MARK: - Variables
    
    weak var delegate: HistoryViewModelDelegate?
    
    var sections: [Section] = []
    var selectedSort: Sort = .day
    var selectedSortEntity: SortEntity?
    
    // MARK: - Variables private
    
    // MARK: - Initializers
    init() { }
    
    // MARK: - Public methods
    
    func loadData(selectedSort: Sort) {
        self.selectedSort = selectedSort
        delegate?.didSelectSort(selectedSort: selectedSort)
        loadTransactions()
    }
    
    func loadTransactions() {
        let service = TransactionService.instance
        
        let operateWithTransactions: ([Transaction]) -> Void = { transactions in
            
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
            
            // sections
            
            let changes = self.changes(oldSections: self.sections, newSections: sections)

            // transactions
            
            sections.forEach { section in
                if let index = self.sections.index(of: section) {
                    let oldTransactions = self.sections[index].transactions
                    let newTransactions = section.transactions
                    
//                    let (inserted, deleted) = self.changes(oldTransactions: oldTransactions,
//                                                           newTransactions: newTransactions,
//                                                           in: index)

                    
                    if oldTransactions.count == newTransactions.count { //means that need to just reload all items in section
                        let updated = Array(0...oldTransactions.count - 1).compactMap { IndexPath(row: $0, section: index) }
                        self.delegate?.didReceiveUpdates(insertions: [], removals: [], updates: updated)
                    } else if oldTransactions.count < newTransactions.count { // need to insert new values and update old ones
                        if !newTransactions.isEmpty {
                            let inserted = Array(oldTransactions.count...newTransactions.count - 1)
                                .compactMap { IndexPath(row: $0, section: index) }
                            
                            var updated: [IndexPath] = []
                            
                            if !oldTransactions.isEmpty {
                                updated = Array(0...oldTransactions.count - 1).compactMap { IndexPath(row: $0, section: index) }
                            }
                            
                            self.sections[index].transactions = newTransactions
                            
                            self.delegate?.didReceiveUpdates(insertions: inserted, removals: [], updates: updated)
                        }
                    } else if oldTransactions.count > newTransactions.count { // need to delete old values and update old ones
                        let deleted = Array(newTransactions.count...oldTransactions.count - 1)
                            .compactMap { IndexPath(row: $0, section: index) }
                        
                        var updated: [IndexPath] = []
                        
                        if !oldTransactions.isEmpty {
                            updated = Array(0...newTransactions.count - 1).compactMap { IndexPath(row: $0, section: index) }
                        }
                        
                        self.sections[index].transactions = newTransactions
                        
                        self.delegate?.didReceiveUpdates(insertions: [], removals: deleted, updates: updated)
                    }
                }
            }
            
            if !changes.0.isEmpty || !changes.1.isEmpty {
                self.sections = sections
                self.delegate?.didReceiveUpdatesForSections(insertions: changes.0, removals: changes.1)
            }
//
//            if !insertions.isEmpty || !removals.isEmpty {
//                self.delegate?.didReceiveUpdates(insertions: insertions, removals: removals)
//            }
            
            self.calculateStatisticsValues(for: transactions.map { TransactionViewModel(transaction: $0) })
        }
        
        let sortEntity: SortEntity = self.getCurrentSortEntity()
        var entity: Entity? = nil
        
        switch sortEntity {
        case .total: entity = nil
            
        case .wallet(entity: let walletEntity):
            entity = walletEntity
        }

        let dates: Calendar.StartEndDate
        let title: String
        
        switch selectedSort {
        case .day:
            dates = Calendar.current.currentDay()
            title = dates.start.shortString
            
        case .week:
            dates = Calendar.current.currentWeek()
            title = dates.start.shortString + " - " + dates.end.shortString
            
        case .month:
            dates = Calendar.current.currentMonth()
            title = dates.start.shortString + " - " + dates.end.shortString

        case .year:
            dates = Calendar.current.currentYear()
            title = dates.start.shortString + " - " + dates.end.shortString

        case .custom(from: let fromDate, to: let toDate):
            let startOfDay = fromDate.startOfDay
            let endOfDay = toDate.endOfDay
            
            title = startOfDay.shortString + " - " + endOfDay.shortString
            
            print("Start ->: \(startOfDay)")
            print("End ->: \(endOfDay))")
            print("-----")
            
            dates = (startOfDay, endOfDay)
        }
        
        service.fetchTransaction(entity: entity, dates: dates, type: nil, completion: operateWithTransactions)
        delegate?.didChooseDate(title: title)
    }
    
    func removeInnerTransactions(_ viewModel: TransactionViewModel) {
        TransactionService.instance.removeTransactions(viewModel.innerTransactions.map({ $0.id }))
//        transactions.value = transactions.value.filter({ $0.id != viewModel.id })
//        calculateStatisticsValues()
    }
    
    func getCurrentSortEntity() -> SortEntity {
        if let selectedSort = selectedSortEntity {
            return selectedSort
        } else if let wallet = WalletsService.instance.fetchCurrentWallet() {
            return .wallet(entity: wallet)
        } else {
            return .total
        }
    }
    
    // MARK: - Private methods
    
    private func calculateStatisticsValues(for transactions: [TransactionViewModel]) {
        var totalIncomes: Double = 0
        var totalOutcomes: Double = 0
        
        transactions.forEach { transaction in
            if transaction.type == .incoming {
                totalIncomes += transaction.value
            } else {
                totalOutcomes += transaction.value
            }
        }
        
        delegate?.didCalculate(incomes: totalIncomes, outcomes: totalOutcomes)
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
    
    private func changes(oldTransactions: [TransactionViewModel],
                         newTransactions: [TransactionViewModel],
                         in section: Int) -> ([Int], [Int]) {
        
        let changes = diff(old: oldTransactions, new: newTransactions)
        
        var inserted: [Int] = []
        var removed: [Int] = []
        var moved: [IndexPath] = []
        var replaced: [IndexPath] = []
        
        changes.forEach { change in
            switch change {
            case .insert(let insert):
                inserted.append(insert.index)
            case .delete(let delete):
                removed.append(delete.index)
            case .move(let move):
                moved.append(IndexPath(row: move.fromIndex, section: section))
            case .replace(let replace):
                replaced.append(IndexPath(row: replace.index, section: section))
            }
        }

        return (inserted, removed)
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
