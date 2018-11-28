//
//  Category.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/27/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class Category {
    
    // MARK: - Variables
    let id: Int
    var title: String
    var imageRaw: Int
    
    // MARK: - Class methods
    class func emptyCategory() -> Category {
        let category = Category(id: 0)
        category.title = "Unknown"
        category.imageRaw = 0
        return category
    }
    
    // MARK: - Initializers
    init(id: Int) {
        self.id = id
        title = ""
        imageRaw = 0
    }
    
    convenience init(db: CategoryDB) {
        self.init(id: db.id)
        title = db.title
        imageRaw = db.imageType
    }
    
    convenience init(viewModel: CategoryViewModel) {
        self.init(id: viewModel.id)
        title = viewModel.title
        imageRaw = viewModel.imageRaw
    }
    
}
