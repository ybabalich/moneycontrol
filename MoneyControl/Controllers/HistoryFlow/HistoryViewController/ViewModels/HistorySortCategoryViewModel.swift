//
//  HistorySortCategoryViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

struct HistorySortCategoryViewModel {
    
    // MARK: - Variables
    let title: String
    let sortType: Sort
    
    init(sort: Sort) {
        title = sort.stringValue
        sortType = sort
    }
    
}
