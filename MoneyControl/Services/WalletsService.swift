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
        cashEntity.title = EntityBaseNamePrefix
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
    
    func fetchCurrentWallet() -> Entity? {
        guard let walletName = settings.wallet else { return nil }
        
        return fetchWallet(name: walletName)
    }
    
    func createWallet(name: String, currency: Currency) {
        let cashEntity = EntityDB()
        cashEntity.title = name.lowercased()
        cashEntity.currency = currency.rawValue
        
        try! db.write {
            db.add(cashEntity)
        }
    }
    
    func deleteWallet(_ entity: Entity) {
        TransactionService.instance.remove(for: entity)

        let objects = db.objects(EntityDB.self).filter("title == %@", entity.title.lowercased())
        try! db.write {
            print("ENTITY REMOVED \(entity.title)")
            db.delete(objects)
        }
    }
    
    func editWallet(oldName: String, newName: String) {
        
        if let object = db.objects(EntityDB.self).filter("title == %@", oldName.lowercased()).first {
            
            try! db.write {
                object.title = newName.lowercased()
            }
        }
    }
    
}
