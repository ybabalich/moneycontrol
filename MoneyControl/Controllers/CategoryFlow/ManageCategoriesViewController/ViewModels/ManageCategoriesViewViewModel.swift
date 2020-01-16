//
//  ManageCategoriesViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/3/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class ManageCategoriesViewViewModel {
    
    // MARK: - Variables public
    let categories = Variable<[CategoryViewModel]>([])
    let selectedTransationType: Variable<Transaction.TransactionType> = Variable<Transaction.TransactionType>(.outcoming)
    
    // MARK: - Variables private
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        selectedTransationType.asObservable().subscribe(onNext: { [unowned self] (value) in
            self.loadCategories()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func loadData() {
        //categories
        loadCategories()
    }
    
    func removeCategory(_ category: CategoryViewModel) {
        categories.value = categories.value.filter({ $0.id != category.id })
        CategoryService.instance.remove(id: category.id)
    }
    
    // MARK: - Private methods
    private func loadCategories() {
        CategoryService.instance.fetchSavedCategories(type: selectedTransationType.value) { [weak self] (categories) in
            guard let strongSelf = self else { return }
            
            strongSelf.categories.value = categories
        }
    }
    
}

