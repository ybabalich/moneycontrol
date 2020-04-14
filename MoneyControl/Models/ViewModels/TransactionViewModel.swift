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
    var id: Int
    var value: Double
    var entity: Entity
    var type: Transaction.TransactionType
    var category: CategoryViewModel
    var innerTransactions: [TransactionViewModel]
    var formattedTime: String
    var createdTime: Date
    
    // MARK: - Initializers
    init(transaction: Transaction) {
        id = transaction.id
        value = transaction.value
        type = transaction.type
        entity = transaction.entity
        category = CategoryViewModel(category: transaction.category)
        innerTransactions = transaction.innerTransactions?.map({ TransactionViewModel(transaction: $0) }) ?? []
        formattedTime = DateService.instance.convertDateToString(transaction.time, format: DateService.dayMonthYearWithSpacesFormat)
        createdTime = transaction.time
    }
    
}
