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
    func fetchSavedCategories(type: Transaction.TransactionType, completion: ([CategoryViewModel]) -> ()) {
        
        if !settings.baseCategoriesAdded { //first time app launched
            saveBaseCategories()
            settings.baseCategoriesAdded = true
        }
        
        let filter = NSPredicate(format: "type == %d && isVisibleForUser == true", argumentArray: [type.rawValue])
        completion(db.objects(CategoryDB.self).filter(filter).map({ CategoryViewModel(db: $0) }))
    }
    
    func remove(id: Int) {
        let filter = NSPredicate(format: "id == %d", argumentArray: [id])
        try! db.write {
            db.delete(db.objects(CategoryDB.self).filter(filter))
        }
    }
    
    // MARK: - Private methods
    private func saveBaseCategories() {
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
        
        try! db.write {
            db.add(incomingCategoriesDB)
            db.add(outcomingCategoriesDB)
        }
    }
    
}
