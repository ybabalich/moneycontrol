//
//  WalletAddViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

protocol WalletAddViewModelDelegate: class {
    func didCreateWallet()
}

class WalletAddViewModel {
    
    struct Section {
        
        enum SectionType {
            case name
            case currency
        }
        
        let title: String?
        let type: SectionType
    }
    
    // MARK: - Variables public
    
    weak var delegate: WalletAddViewModelDelegate?
    var sections: [Section] = []
    
    // MARK: - Public methods
    
    func loadData() {
        
        sections = [
            Section(title: "Name", type: .name)
        ]
    }
    
    func createWallet(name: String, currency: Currency, startBalance: Double) {
        WalletsService.instance.createWallet(name: name, currency: currency)
        
        delegate?.didCreateWallet()
    }
    
}
