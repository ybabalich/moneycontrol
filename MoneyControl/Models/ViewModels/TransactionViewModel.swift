//
//  TransactionViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/27/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class TransactionViewModel {
    
    // MARK: - Variables
    var value: Double
    var type: Transaction.TransactionType
    var category: CategoryViewModel
    
    // MARK: - Initializers
    init(transaction: Transaction) {
        value = transaction.value
        type = transaction.type
        category = CategoryViewModel(category: transaction.category)
    }
    
}
