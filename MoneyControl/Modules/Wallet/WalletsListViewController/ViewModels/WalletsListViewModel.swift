//
//  WalletsListViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

protocol WalletsListViewModelDelegate: class {
    func didSelect(sortEntity: SortEntity)
}

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
    
    weak var delegate: WalletsListViewModelDelegate?
    var sections: [Section] = []
    var selectedEntity: SortEntity?
    
    // MARK: - Initialziers
    
    init() {
        
    }
    
    // MARK: - Public methods
    
    func totalBalance() -> String {
        TransactionService.instance.fetchBalance(for: nil).currencyFormattedWithSymbol
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
    
    func isSelected(indexPath: IndexPath) -> Bool {
        guard let selectedEntity = selectedEntity else { return false }
        
        let section = sections[indexPath.section]
        
        switch section.type {
        case .total:
            
            if selectedEntity == .total {
                return true
            }
            
        case .wallets(wallets: let entities):
            
            switch selectedEntity {
            case .wallet(entity: let entity):
                
                if entities[indexPath.row] == entity {
                    return true
                }
                
            default: print("Nothing")
            }
        }
        
        return false
    }
    
}
