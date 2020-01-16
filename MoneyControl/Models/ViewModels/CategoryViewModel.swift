//
//  Category.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class CategoryViewModel {
    
    enum CategoryImageType: Int {
        case fuel
        case shopping
        case food
        case coffee
        case payments
        case spa
        case gym
        case car
        case pharmacy
        case rent
        case restaurant
        case train
        case smoke
        case travel
        case game
        case fly
        case salary
        
        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .fuel
            case 1: self = .shopping
            case 2: self = .food
            case 3: self = .coffee
            case 4: self = .payments
            case 5: self = .spa
            case 6: self = .gym
            case 7: self = .car
            case 8: self = .pharmacy
            case 9: self = .rent
            case 10: self = .restaurant
            case 11: self = .train
            case 12: self = .smoke
            case 13: self = .travel
            case 14: self = .game
            case 15: self = .fly
            case 16: self = .salary
            default: self = .fuel
            }
        }
        
        var image: UIImage {
            switch self {
            case .fuel: return UIImage(named: "ic_category_fuel")!
            case .shopping: return UIImage(named: "ic_category_shopping")!
            case .food: return UIImage(named: "ic_category_food")!
            case .coffee: return UIImage(named: "ic_category_coffee")!
            case .payments: return UIImage(named: "ic_category_payments")!
            case .spa: return UIImage(named: "ic_category_spa")!
            case .gym: return UIImage(named: "ic_category_gym")!
            case .car: return UIImage(named: "ic_category_car")!
            case .pharmacy: return UIImage(named: "ic_category_pharmacy")!
            case .rent: return UIImage(named: "ic_category_rent")!
            case .restaurant: return UIImage(named: "ic_category_restaurant")!
            case .train: return UIImage(named: "ic_category_train")!
            case .smoke: return UIImage(named: "ic_category_smoking")!
            case .travel: return UIImage(named: "ic_category_travel")!
            case .game: return UIImage(named: "ic_category_games")!
            case .fly: return UIImage(named: "ic_category_fly")!
            case .salary: return UIImage(named: "ic_category_salary")!
            }
        }
    }
    
    // MARK: - Variables
    let id: Int
    let title: String
    let image: UIImage
    let imageRaw: Int
    
    // MARK: - Initial methods
    init(db: CategoryDB) {
        self.id = db.id
        self.title = db.title.localized
        self.image = CategoryImageType(rawValue: db.imageType).image
        self.imageRaw = db.imageType
    }
    
    convenience init(category: Category) {
        self.init(id: category.id, title: category.title.localized, imageRaw: category.imageRaw)
    }
    
    init(id: Int, title: String, imageType: CategoryImageType) {
        self.id = id
        self.title = title
        self.image = imageType.image
        self.imageRaw = imageType.rawValue
    }
    
    init(id: Int, title: String, imageRaw: Int) {
        self.id = id
        self.title = title
        
        let imageType = CategoryImageType(rawValue: imageRaw)
        
        self.image = imageType.image
        self.imageRaw = imageRaw
    }
}
