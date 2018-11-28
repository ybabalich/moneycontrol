//
//  CategoriesFabric.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class CategoriesFabric {
    
    // MARK: - Public methods
    static func initialCategories() -> [CategoryViewModel] {
        let fuel = CategoryViewModel(id: 0, title: "Fuel", imageType: .fuel)
        let shopping = CategoryViewModel(id: 1, title: "Shopping", imageType: .shopping)
        let food = CategoryViewModel(id: 2, title: "Food", imageType: .food)
        let coffee = CategoryViewModel(id: 3, title: "Coffee", imageType: .coffee)
        let payments = CategoryViewModel(id: 4, title: "Payments", imageType: .payments)
        let spa = CategoryViewModel(id: 5, title: "Spa", imageType: .spa)
        let gym = CategoryViewModel(id: 6, title: "Gym", imageType: .gym)
        return [fuel, shopping, food, coffee, payments, spa, gym]
    }
    
}
