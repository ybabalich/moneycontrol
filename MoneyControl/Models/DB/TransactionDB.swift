//
//  TransactionDB.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/27/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RealmSwift

class TransactionDB: Object {
    
    // MARK: - Variables
    
    @objc dynamic var id: Int = 0
    @objc dynamic var value: Double = 0
    @objc dynamic var entity: EntityDB? = nil
//    @objc dynamic var currency: Int = 0
    @objc dynamic var type: Int = 0
    @objc dynamic var categoryId: Int = 0
    @objc dynamic var time = Date()
    
}
