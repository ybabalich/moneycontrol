//
//  WalletAddNameTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class WalletAddNameTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private var nameField: LimitedTextField!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("WalletAddNameTableViewCell")
    }
    
    // MARK: - Public methods
    
    func getNameField() -> LimitedTextField {
        return nameField
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        tintColor = .controlTintActive
        backgroundColor = .mainElementBackground
        selectedBackgroundView = UIView().then { $0.backgroundColor = .mainElementBackground }
        
        separatorInset = UIEdgeInsets(top: 0, left: 30 + 16, bottom: 0, right: 0)
        
        nameField = LimitedTextField().then { nameField in
            
            nameField.enterType = .charactersLimit(range: 0...15, isNumeric: false)
            nameField.placeholder = "wallets.add.nameField.placeholder".localized
            nameField.font = .systemFont(ofSize: 18, weight: .bold)
            nameField.textColor = .primaryText
            
            contentView.addSubview(nameField)
            nameField.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.top.bottom.equalToSuperview()
                $0.height.equalTo(60)
            }
        }
    }
}
