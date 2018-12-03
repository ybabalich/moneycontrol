//
//  EditTransactionViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class EditTransactionViewViewModel {
    
    // MARK: - Variables public
    let transaction = PublishSubject<TransactionViewModel>()
    
    // MARK: - Variables private
    private let _transaction = Variable<TransactionViewModel?>(nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        _transaction.asObservable().subscribe(onNext: { [unowned self] (transactionViewModel) in
            guard let transactionViewModel = transactionViewModel else { return }
            
            self.transaction.onNext(transactionViewModel)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func applyTransaction(_ transaction: TransactionViewModel) {
        _transaction.value = transaction
    }
    
}
