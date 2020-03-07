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
        let transfer = CategoryViewModel(id: 16, title: "Transfer", imageType: .transfer)
        let salary = CategoryViewModel(id: 17, title: "Salary", imageType: .salary)
        let deposit = CategoryViewModel(id: 18, title: "Deposit", imageType: .deposit)
        let startBalance = CategoryViewModel(id: 19, title: "Start Balance", imageType: .startBalance)
        
        return [fuel, car, shopping, food, coffee,
                payments, spa, gym, pharmacy, rent,
                restaurant, train, smoke, travel, game, fly, transfer, salary, deposit, startBalance]
    }
    
    static func incomeCategories() -> [CategoryViewModel] {
        return Array(CategoriesFabric.initialCategories()[17...18])
    }
    
    static func expenseCategories() -> [CategoryViewModel] {
        return Array(CategoriesFabric.initialCategories()[0...16])
    }
    
    static func startBalanceCategory() -> CategoryViewModel {
        let category = CategoryViewModel(id: 19, title: "Start Balance", imageType: .startBalance)
        category.isVisibleForUser = false
        return category
    }
    
}
