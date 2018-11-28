//
//  ActivityViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/27/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class ActivityViewViewModel {
    
    enum KeyboardButtonType {
        case zero
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case dot
        case clear
    }
    
    // MARK: - Variables public
    let value: PublishSubject<String> = PublishSubject<String>()
    let isHiddenField: PublishSubject<Bool> = PublishSubject<Bool>()
    let categories: Variable<[CategoryViewModel]> = Variable<[CategoryViewModel]>([])
    let selectedCategory: Variable<CategoryViewModel?> = Variable<CategoryViewModel?>(nil)
    let transactionType: PublishSubject<Transaction.TransactionType> = PublishSubject<Transaction.TransactionType>()
    
    // MARK: - Variables private
    private let _transactionValue: Variable<String> = Variable<String>("")
    private let _transactionType: Variable<Transaction.TransactionType> = Variable<Transaction.TransactionType>(.incoming)
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        _transactionValue.asObservable().subscribe(onNext: { [unowned self] (value) in
            if value.count > 0 {
                self.value.onNext(value)
                self.isHiddenField.onNext(false)
            } else {
                self.value.onNext("")
                self.isHiddenField.onNext(true)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func loadData() {
        transactionType.onNext(_transactionType.value)
        fetchCategories()
    }
    
    func changeTransactionType() {
        if _transactionType.value == .incoming {
            _transactionType.value = .outcoming
        } else {
            _transactionType.value = .incoming
        }
        
        transactionType.onNext(_transactionType.value)
    }
    
    func keyboardValue(_ type: KeyboardButtonType) {
        
        switch type {
        case .zero: _transactionValue.value.append("0")
        case .one: _transactionValue.value.append("1")
        case .two: _transactionValue.value.append("2")
        case .three: _transactionValue.value.append("3")
        case .four: _transactionValue.value.append("4")
        case .five: _transactionValue.value.append("5")
        case .six: _transactionValue.value.append("6")
        case .seven: _transactionValue.value.append("7")
        case .eight: _transactionValue.value.append("8")
        case .nine: _transactionValue.value.append("9")
        case .dot:
            if !_transactionValue.value.contains(".") {
                _transactionValue.value.append(".")
            }
        case .clear:
            if _transactionValue.value.count > 0 {
                _transactionValue.value.removeLast()
            }
        }
    }
    
    func saveTransaction() {
        guard let selectedCategory = selectedCategory.value else { return }
        
        let category = Category(viewModel: selectedCategory)
        
        let transaction = Transaction()
        transaction.value = Double(_transactionValue.value)!
        transaction.type = _transactionType.value
        transaction.category = category
        transaction.time = Date()
        
        TransactionService.instance.save(transaction)
        
        _transactionValue.value.removeAll()
    }
    
    // MARK: - Private methods
    private func fetchCategories() {
        CategoryService.instance.fetchMyCategories { [weak self] (categories) in
            guard let strongSelf = self else { return }
            
            strongSelf.categories.value = categories
            strongSelf.selectedCategory.value = categories[0]
        }
    }
    
}
