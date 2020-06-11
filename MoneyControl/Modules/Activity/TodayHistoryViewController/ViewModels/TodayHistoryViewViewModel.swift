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
    let transactions = Variable<[TransactionViewModel]>([])
    
    // MARK: - Variables private
    private let disposeBag = DisposeBag()

    // MARK: - Public methods
    func loadData(for segment: Segment) {
        
        let transactionType: Transaction.TransactionType?
        
        switch segment {
        case .revenues: transactionType = .incoming
        case .spendings: transactionType = .outcoming
        default: transactionType = nil
        }
        
        TransactionService.instance.fetchTodayTransactions(for: getCurrentWallet(), type: transactionType) { (transactions) in
            let transactions = transactions.map({ (transaction) -> TransactionViewModel in
                return TransactionViewModel(transaction: transaction)
            })
            
            self.transactions.value = transactions
        }
    }
    
    func getCurrentWallet() -> Entity? {
        WalletsService.instance.fetchCurrentWallet()
    }
    
    func remove(_ transaction: TransactionViewModel) {
        TransactionService.instance.remove(id: transaction.id)
        transactions.value = transactions.value.filter({ $0.id != transaction.id })
    }
    
}

extension TodayHistoryViewViewModel {
    
    enum Segment: String, Localizable, CaseIterable {
        case all = "All"
        case revenues = "Revenues"
        case spendings = "Spendings"

        static let allCasesLocalized = Self.allCases.map { $0.localized }

        var index: Int {
            switch self {
            case .all: return 0
            case .revenues: return 1
            case .spendings: return 2
            }
        }

        init(index: Int) {
            switch index {
            case 0: self = .all
            case 1: self = .revenues
            case 2: self = .spendings
            default: fatalError("Cannot instantiate Segment from index #\(index)")
            }
        }
    }
}
