//
//  WalletsTotalTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class WalletsTotalTableViewCell: UITableViewCell {

    // MARK: - UI
    
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
    
    func showBalance(_ balance: String) {
        bottomLabel.text = balance
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        tintColor = .controlTintActive
        backgroundColor = .mainElementBackground
        selectedBackgroundView = UIView().then { $0.backgroundColor = .mainElementBackground }
        
        separatorInset = UIEdgeInsets(top: 0, left: 30 + 16, bottom: 0, right: 0)
        
        topLabel = UILabel().then { topLabel in
            
            topLabel.numberOfLines = 1
            topLabel.text = "Total"
            topLabel.font = .systemFont(ofSize: 18, weight: .bold)
            topLabel.textColor = .primaryText
            
            contentView.addSubview(topLabel)
            topLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.top.equalToSuperview().offset(10)
            }
        }
        
        bottomLabel = UILabel().then { bottomLabel in
            
            bottomLabel.numberOfLines = 1
            bottomLabel.font = .systemFont(ofSize: 16)
            bottomLabel.textColor = .primaryText
            
            contentView.addSubview(bottomLabel)
            bottomLabel.snp.makeConstraints {
                $0.top.equalTo(topLabel.snp.bottom).offset(6)
                $0.left.equalToSuperview().offset(16)
                $0.bottom.equalToSuperview().inset(10)
            }
        }
    }
}
