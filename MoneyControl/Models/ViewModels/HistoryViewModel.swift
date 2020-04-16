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
    let sort: Sort
    let category: CategoryViewModel
    
    // MARK: - Initializers
    init(sort: Sort, category: CategoryViewModel) {
        self.sort = sort
        self.category = category
    }
    
}
