//
//  ChooseCategoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/20/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import RxSwift

class ChooseCategoryViewViewModel {
    
    // MARK: - Variables public
    let categories = Variable<[CategoryViewModel]>([])
    let selectedCategory = Variable<CategoryViewModel?>(nil)
    let selectedTransationType = Variable<Transaction.TransactionType>(.outcoming)
    
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
    
    func selectCategory(_ indexPath: IndexPath) {
        selectedCategory.value = categories.value[indexPath.row]
    }
    
    // MARK: - Private methods
    private func loadCategories() {
        CategoryService.instance.fetchSavedCategories(type: selectedTransationType.value) { [weak self] (categories) in
            guard let strongSelf = self else { return }
            
            strongSelf.categories.value = categories
        }
    }
    
}

