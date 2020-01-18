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
    let isSuccess = PublishSubject<Bool>()
    
    // MARK: - Variables private
    private var transactionDate: Date?
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
    
    func changeDate(to date: Date) {
        transactionDate = date
    }
    
    func selectCategory(_ category: CategoryViewModel) {
        let transaction = _transaction.value
        transaction?.category = category
        _transaction.value = transaction
    }
    
    func updateTransaction(value: Double, categoryId: Int) {
        guard let transaction = _transaction.value else { return }
        
        transaction.value = value
        transaction.category = CategoryViewModel(category: Category(id: categoryId))
        
        if let trasactionDate = transactionDate {
            transaction.createdTime = trasactionDate
        }
        
        let transactionToSave = Transaction(viewModel: transaction)
        TransactionService.instance.update(transactionToSave)
        
        isSuccess.onNext(true)
    }
    
    func removeTransaction() {
        guard let transaction = _transaction.value else { return }
        
        TransactionService.instance.remove(id: transaction.id)
        
        isSuccess.onNext(true)
    }
    
}
