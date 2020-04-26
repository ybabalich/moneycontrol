//
//  WalletAddBalanceTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class WalletAddBalanceTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private var balanceField: LimitedTextField!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("WalletAddNameTableViewCell")
    }
    
    // MARK: - Public methods
    
    func getBalanceField() -> LimitedTextField {
        return balanceField
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        tintColor = .controlTintActive
        backgroundColor = .mainElementBackground
        selectedBackgroundView = UIView().then { $0.backgroundColor = .mainElementBackground }
        
        separatorInset = UIEdgeInsets(top: 0, left: 30 + 16, bottom: 0, right: 0)
        
        balanceField = LimitedTextField().then { balanceField in
            
            balanceField.enterType = .numbers(symbolsAfterDot: 2)
            balanceField.placeholder = "general.balance".localized
            balanceField.font = .systemFont(ofSize: 18, weight: .bold)
            balanceField.textColor = .primaryText
            
            contentView.addSubview(balanceField)
            balanceField.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.top.bottom.equalToSuperview()
                $0.height.equalTo(60)
            }
        }
    }
}
