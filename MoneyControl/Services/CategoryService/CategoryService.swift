//
//  CategoryService.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class CategoryService {
    
    // MARK: - Singleton
    static let instance = CategoryService()
    
    // MARK: - Public methods
    func fetchSavedCategories(type: Transaction.TransactionType, completion: ([CategoryViewModel]) -> ()) {
        let filter = NSPredicate(format: "type == %d && isVisibleForUser == true", type.rawValue)
        completion(db.objects(CategoryDB.self).filter(filter).map { CategoryViewModel(db: $0) } )
    }
    
    func remove(id: Int) {
        let filter = NSPredicate(format: "id == %d", argumentArray: [id])
        try! db.write {
            db.delete(db.objects(CategoryDB.self).filter(filter))
        }
    }
    
    func saveBaseCategories() {
        var categories = CategoriesFabric.incomeCategories()
        categories.append(CategoriesFabric.startBalanceCategory())
        
        let incomingCategoriesDB = categories.map { (categoryViewModel) -> CategoryDB in
            let categoryDb = CategoryDB()
            categoryDb.id = categoryViewModel.id
            categoryDb.title = categoryViewModel.title
            categoryDb.imageType = categoryViewModel.imageRaw
            categoryDb.type = Transaction.TransactionType.incoming.rawValue
            categoryDb.isVisibleForUser = categoryViewModel.isVisibleForUser
            return categoryDb
        }
        
        let outcomingCategoriesDB = CategoriesFabric.expenseCategories().map { (categoryViewModel) -> CategoryDB in
            let categoryDb = CategoryDB()
            categoryDb.id = categoryViewModel.id
            categoryDb.title = categoryViewModel.title
            categoryDb.imageType = categoryViewModel.imageRaw
            categoryDb.type = Transaction.TransactionType.outcoming.rawValue
            categoryDb.isVisibleForUser = categoryViewModel.isVisibleForUser
            return categoryDb
        }
        
        let allCategories: [CategoryDB] = incomingCategoriesDB + outcomingCategoriesDB
        
        try! db.write {
            db.add(allCategories)
        }
    }
    
}
