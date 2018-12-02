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
        self.title = db.title
        self.image = CategoryImageType(rawValue: db.imageType).image
        self.imageRaw = db.imageType
    }
    
    convenience init(category: Category) {
        self.init(id: category.id, title: category.title, imageRaw: category.imageRaw)
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
