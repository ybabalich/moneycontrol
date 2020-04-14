//
//  EntityDB.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import RealmSwift

class EntityDB: Object {
    
    // MARK: - Variables
    
    @objc dynamic var title: String = ""
    @objc dynamic var currency: Int = 0
    
}
