//
//  EditTransactionViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

protocol EditTransactionViewModelDelegate: class {
    func didChangeSaveBtnStatus(isActive: Bool)
    func didUpdateData()
    func didSaveData()
}

class EditTransactionViewModel {
    
    struct Section {
        
        enum SectionType {
            case amount
            case category
            case date
            case entity
        }
        
        let title: String
        let type: SectionType
    }
    
    // MARK: - Variables public
    
    var sections: [Section] = []
    let transaction: TransactionViewModel
    weak var delegate: EditTransactionViewModelDelegate?
    
    // MARK: - Variables private
    
    private var selectedAmount: Double?
    private var selectedCategory: CategoryViewModel?
    private var selectedDate: Date?

    
    // MARK: - Initializers
    init(transaction: TransactionViewModel) {
        self.transaction = transaction
    }
    
    // MARK: - Public methods
    
    func loadData() {
        sections = [
            Section(title: "transaction.edit.amount".localized, type: .amount),
            Section(title: "transaction.edit.category".localized, type: .category),
            Section(title: "transaction.edit.date".localized, type: .date)
        ]
        
        compareFilledData()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        
        delegate?.didUpdateData()
        
        compareFilledData()
    }
    
    func filledDate() -> String {
        if let selectedDate = selectedDate {
            return selectedDate.shortString
        } else {
            return transaction.createdTime.shortString
        }
    }
    
    func selectCategory(_ category: CategoryViewModel) {
        selectedCategory = category
        
        delegate?.didUpdateData()
        
        compareFilledData()
    }
    
    func filledCategory() -> CategoryViewModel {
        if let selectedCategory = selectedCategory {
            return selectedCategory
        } else {
            return transaction.category
        }
    }
    
    func selectAmount(_ amount: Double) {
        selectedAmount = amount
        
        compareFilledData()
    }
    
    func filledAmount() -> String {
        if let selectedAmount = selectedAmount {
            return "\(selectedAmount)"
        } else {
            return "\(transaction.value)"
        }
    }
    
    func save() {
        
        let transactionVM = transaction
        
        if let selectedCategory = selectedCategory {
            transactionVM.category = selectedCategory
        }
        
        if let selectedDate = selectedDate {
            transactionVM.createdTime = selectedDate
        }
        
        if let selectedAmount = selectedAmount {
            transactionVM.value = selectedAmount
        }
        
        TransactionService.instance.update(Transaction(viewModel: transactionVM))
        
        delegate?.didSaveData()
    }
    
    // MARK: - Private methods
    
    private func compareFilledData() {
        
        var isEqualData = false
        
        let allNillState: Bool = selectedAmount == nil && selectedCategory == nil && selectedDate == nil
        let amountState: Bool = selectedAmount == transaction.value || selectedAmount == nil
        let categoryState: Bool = selectedCategory == transaction.category || selectedCategory == nil
        let dateState: Bool = selectedDate?.createDMY() == transaction.createdTime.createDMY() || selectedDate?.createDMY() == nil
        
        if (amountState && categoryState && dateState) || allNillState {
            isEqualData = true
        }

        delegate?.didChangeSaveBtnStatus(isActive: !isEqualData)
    }
}
