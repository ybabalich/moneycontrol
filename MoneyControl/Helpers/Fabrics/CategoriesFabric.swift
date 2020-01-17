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
        let car = CategoryViewModel(id: 7, title: "Car", imageType: .car)
        let pharmacy = CategoryViewModel(id: 8, title: "Pharmacy", imageType: .pharmacy)
        let rent = CategoryViewModel(id: 9, title: "Rent", imageType: .rent)
        let restaurant = CategoryViewModel(id: 10, title: "Restaurant", imageType: .restaurant)
        let train = CategoryViewModel(id: 11, title: "Train", imageType: .train)
        let smoke = CategoryViewModel(id: 12, title: "Smoke", imageType: .smoke)
        let travel = CategoryViewModel(id: 13, title: "Travel", imageType: .travel)
        let game = CategoryViewModel(id: 14, title: "Game", imageType: .game)
        let fly = CategoryViewModel(id: 15, title: "Fly", imageType: .fly)
        let salary = CategoryViewModel(id: 16, title: "Salary", imageType: .salary)
        
        return [fuel, car, shopping, food, coffee,
                payments, spa, gym, pharmacy, rent,
                restaurant, train, smoke, travel, game, fly, salary]
    }
    
    static func incomeCategories() -> [CategoryViewModel] {
        return [CategoriesFabric.initialCategories()[16]]
    }
    
    static func expenseCategories() -> [CategoryViewModel] {
        return Array(CategoriesFabric.initialCategories()[0...15])
    }
    
    static func startBalanceCategory() -> CategoryViewModel {
        let category = CategoryViewModel(id: 17, title: "Start Balance", imageType: .startBalance)
        return category
    }
    
}
