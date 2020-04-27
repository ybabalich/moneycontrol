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
    private var balanceValue: Double = 0.0
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        
    }
    
    // MARK: - Public methods
    func loadData(balanceObs: Observable<String>) {
        balanceObs.asObservable().subscribe(onNext: { (value) in
            self.balanceValue = value.double
        }).disposed(by: disposeBag)
        balanceObs.map { $0.double != 0 }.bind(to: isActiveSaveBtn).disposed(by: disposeBag)
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
        transaction.value = balanceValue
        transaction.type = .incoming
        transaction.category = category
        transaction.time = Date()
        
        if let entity = WalletsService.instance.fetchCurrentWallet() {
            transaction.entity = entity
        }
        
        TransactionService.instance.save(transaction)
    }
    
}
