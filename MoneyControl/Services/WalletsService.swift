//
//  WalletsService.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class WalletsService {
    
    // MARK: - Singleton
    
    static let instance = WalletsService()
    
    // MARK: - Public methods
    
    func saveFirstTimeWallets() {
        let cashEntity = EntityDB()
        cashEntity.title = "monobank uah"
        cashEntity.currency = Currency.uah.rawValue
        
        settings.wallet = cashEntity.title
        
        try! db.write {
            db.add(cashEntity)
        }
    }
    
    func fetchAllWallets(completion: TypeClosure<[Entity]>) {
        completion( db.objects(EntityDB.self).compactMap { Entity(db: $0) } )
    }
    
    func fetchWallet(name: String) -> Entity? {
        guard let entityDB = db.objects(EntityDB.self).filter("title == %@", name.lowercased()).first else {
            return nil
        }
        
        return Entity(db: entityDB)
    }
    
    func createWallet(name: String, currency: Currency) {
        let cashEntity = EntityDB()
        cashEntity.title = name.lowercased()
        cashEntity.currency = currency.rawValue
        
        try! db.write {
            db.add(cashEntity)
        }
    }
    
}
