//
//  WalletsListViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class WalletsListViewModel {
    
    struct Section {
        
        enum SectionType {
            case total
            case wallets(wallets: [Entity])
        }
        
        let title: String?
        let type: SectionType
        
    }
    
    // MARK: - Variables public
    
    var sections: [Section] = []
    
    // MARK: - Initialziers
    
    init() {
        
    }
    
    // MARK: - Public methods
    
    func totalBalance() -> String {
        TransactionService.instance.fetchBalance(for: nil).currencyFormatted
    }
    
    func loadData() {
        WalletsService.instance.fetchAllWallets { [weak self] entities in
            guard let strongSelf = self else { return }
            
            strongSelf.sections = [
                Section(title: nil, type: .total),
                Section(title: "Wallets", type: .wallets(wallets: entities))
            ]
        }
    }
    
    func selectWallet(_ wallet: Entity) {
        settings.wallet = wallet.title
    }
    
}
