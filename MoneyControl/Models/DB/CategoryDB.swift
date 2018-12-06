//
//  CategoryDB.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RealmSwift

class CategoryDB: Object {
    
    // MARK: - Variables
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var imageType: Int = 0
    @objc dynamic var type: Int = 0
    
}
