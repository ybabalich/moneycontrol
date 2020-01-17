//
//  YourBalanceViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/19/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import RxSwift

class YourBalanceViewViewModel {
    
    // MARK: - Public variables
    let isSuccess = PublishSubject<Bool>()
    let isActiveSaveBtn = Variable<Bool>(false)
    
    // MARK: - Private methods
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        
    }
    
    // MARK: - Public methods
    func loadData(balanceObs: Observable<String>) {
        balanceObs.map { $0.count > 0 }.bind(to: isActiveSaveBtn).disposed(by: disposeBag)
    }
    
    func currencySymbol() -> String {
        return settings.currency!.symbol
    }
    
    func save() {
        saveTransaction()
        isSuccess.onNext(true)
    }
    
    // MARK: - Private methods
    private func saveTransaction() {
        let category = Category(viewModel: CategoriesFabric.startBalanceCategory())
        
        let transaction = Transaction()
        transaction.value = 1000.0
        transaction.type = .incoming
        transaction.category = category
        transaction.time = Date()
        
        TransactionService.instance.save(transaction)
    }
    
}
