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
        cashEntity.id = Int.generateID()
        cashEntity.title = EntityBaseNamePrefix
        cashEntity.currency = Currency.uah.rawValue
        
        settings.wallet = cashEntity.id
        
        try! db.write {
            db.add(cashEntity)
        }
    }
    
    func fetchAllWallets(completion: TypeClosure<[Entity]>) {
        completion( db.objects(EntityDB.self).compactMap { Entity(db: $0) } )
    }
    
    func fetchWallet(id: Int) -> Entity? {
        guard let entityDB = db.objects(EntityDB.self).filter("id == %d", id).first else {
            return nil
        }
        
        return Entity(db: entityDB)
    }
    
    func fetchCurrentWallet() -> Entity? {
        guard let walletId = settings.wallet else { return nil }
        
        return fetchWallet(id: walletId)
    }
    
    @discardableResult
    func createWallet(name: String, currency: Currency) -> Entity {
        let cashEntity = EntityDB()
        cashEntity.id = Int.generateID()
        cashEntity.title = name.lowercased()
        cashEntity.currency = currency.rawValue
        
        try! db.write {
            db.add(cashEntity)
        }
        
        return Entity(db: cashEntity)
    }
    
    func deleteWallet(_ entity: Entity) {
        TransactionService.instance.remove(for: entity)

        let objects = db.objects(EntityDB.self).filter("id == %d", entity.id)
        try! db.write {
            print("ENTITY REMOVED \(entity.title)")
            db.delete(objects)
        }
    }
    
    func editWallet(id: Int, newName: String) {
        
        if let object = db.objects(EntityDB.self).filter("id == %d", id).first {
            
            try! db.write {
                object.title = newName.lowercased()
            }
        }
    }
    
}
