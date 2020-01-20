//
//  HistoryViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 19.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class HistoryViewModel {
    
    // MARK: - Variables public
    let sortCategory: HistorySortCategoryViewModel
    let category: CategoryViewModel
    
    // MARK: - Initializers
    init(sortCategory: HistorySortCategoryViewModel, category: CategoryViewModel) {
        self.sortCategory = sortCategory
        self.category = category
    }
    
}
