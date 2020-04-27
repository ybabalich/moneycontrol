//
//  WalletAddViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import RxSwift

protocol WalletAddViewModelDelegate: class {
    func didSuccessFinish()
    func isValidFields(_ isValid: Bool)
}

class WalletAddViewModel {
    
    enum State {
        case add
        case edit(entity: Entity)
    }
    
    struct Section {
        
        enum SectionType {
            case name
            case currency
            case startingBalance
        }
        
        let title: String?
        let type: SectionType
    }
    
    // MARK: - Variables public
    
    weak var delegate: WalletAddViewModelDelegate?
    var sections: [Section] = []
    var state: State = .add
    
    var newName: String?
    var newBalance: String?
    
    // prefilled information
    
    var prefilledName: String? {
        switch state {
        case .add: return nil
        case .edit(entity: let entity): return entity.title.capitalized
        }
    }
    
    // MARK: - Public methods
    
    func loadData() {
        
        sections = [
            Section(title: "general.name".localized, type: .name),
        ]
        
        switch state {
        case .add: sections.append(Section(title: "wallets.add.startingBalance.title".localized, type: .startingBalance))
        default: print("No need to add anything")
        }
        
        checkValidation(name: prefilledName, balance: nil)
    }
    
    func checkValidation(name: String?, balance: String?) {
        guard let name = name, name.count > 0 else {
            delegate?.isValidFields(false)
            return
        }
        
        newName = name
        newBalance = balance
        
        if let balance = balance?.trimmed.nullable {
            delegate?.isValidFields(balance.isDouble)
        } else {
            delegate?.isValidFields(true)
        }
    }
    
    func createWallet() {
        guard let name = newName else { return }
        
        switch state {
        case .add:
            WalletsService.instance.createWallet(name: name, currency: .uah)
            
            if let balance = newBalance?.trimmed.nullable, balance.double > 0 {
                let transaction = Transaction()
                transaction.value = balance.double
                transaction.entity = Entity(id: Int.generateID(), title: name, currency: .uah)
                transaction.category = Category(viewModel: CategoriesFabric.startBalanceCategory())
                
                TransactionService.instance.save(transaction)
            }
            
            delegate?.didSuccessFinish()
        case .edit: return
        }
    }
    
    func editWallet() {
        guard let name = newName else { return }
        
        switch state {
        case .add: return
        case .edit(entity: let wallet):
            wallet.changeName(name)
            delegate?.didSuccessFinish()
        }
    }
}
