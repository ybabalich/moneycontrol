//
//  WalletTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private var walletImage: UIImageView!
    private var topLabel: UILabel!
    private var bottomLabel: UILabel!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("WalletTableViewCell")
    }
    
    // MARK: - Public methods
    
    func apply(_ wallet: Entity) {
        walletImage.image = wallet.title.initials().coverImage
        topLabel.text = wallet.title.uppercased()
        bottomLabel.text = TransactionService.instance.fetchBalance(for: wallet).currencyFormatted
        accessoryType = wallet.isActive ? .checkmark : .none
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        tintColor = .controlTintActive
        backgroundColor = .mainElementBackground
        selectionStyle = .none
        
        separatorInset = UIEdgeInsets(top: 0, left: 30 + 16 + 16, bottom: 0, right: 0)
        
        walletImage = UIImageView().then { walletImage in
            
            walletImage.applyFullyRounded(15)
            walletImage.backgroundColor = .red
            
            contentView.addSubview(walletImage)
            walletImage.snp.makeConstraints {
                $0.width.height.equalTo(30)
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
            }
        }
        
        topLabel = UILabel().then { topLabel in
            
            topLabel.numberOfLines = 1
            topLabel.text = "Cash"
            topLabel.font = .systemFont(ofSize: 14)
            topLabel.textColor = .primaryText
            
            contentView.addSubview(topLabel)
            topLabel.snp.makeConstraints {
                $0.left.equalTo(walletImage.snp.right).offset(16)
                $0.top.equalToSuperview().offset(12)
            }
        }
        
        bottomLabel = UILabel().then { bottomLabel in
            
            bottomLabel.text = "$ 40.000"
            bottomLabel.numberOfLines = 1
            bottomLabel.font = .systemFont(ofSize: 14, weight: .bold)
            bottomLabel.textColor = .primaryText
            
            contentView.addSubview(bottomLabel)
            bottomLabel.snp.makeConstraints {
                $0.top.equalTo(topLabel.snp.bottom).offset(4)
                $0.left.equalTo(walletImage.snp.right).offset(16)
                $0.bottom.equalToSuperview().inset(12)
            }
        }
    }
}
