//
//  CategoryService.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class CategoryService: RealmBasedService {
    
    // MARK: - Singleton
    static let instance = CategoryService()
    
    // MARK: - Public methods
    func fetchMyCategories(completion: ([CategoryViewModel]) -> ()) {
        completion(CategoriesFabric.initialCategories())
    }
    
}
