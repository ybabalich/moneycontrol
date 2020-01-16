//
//  ChooseCurrencyViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/18/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import RxSwift

class ChooseCurrencyViewViewModel {
    
    // MARK: - Variables
    let isSuccess = PublishSubject<Bool>()
    let currencies = Variable<[Currency]>([])
    let selectedCurrency = Variable<Currency?>(nil)
    let isActiveSaveBtn = Variable<Bool>(false)
    
    // MARK: - Variables private
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        selectedCurrency.asObservable().map { $0 != nil }.bind(to: isActiveSaveBtn).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func loadData() {
        currencies.value = [.uah, .usd, .rub]
    }
    
    func selectCurrency(_ indexPath: IndexPath) {
        selectedCurrency.value = currencies.value[indexPath.row]
    }
    
    func save() {
        settings.currency = selectedCurrency.value!
        isSuccess.onNext(true)
    }
    
}
