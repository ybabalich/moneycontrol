//
//  ActivityTitleView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class ActivityTitleView: UIView {

    // MARK: - UI
    
    private var firstLabel: UILabel!
    private var secondLabel: UILabel!
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func show(wallet: Entity) {
        
        //titles
        
        firstLabel.text = wallet.title.uppercased()
        secondLabel.text = TransactionService.instance.fetchBalance(for: wallet).currencyFormatted
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        firstLabel = UILabel().then {
            
            $0.numberOfLines = 1
            $0.textColor = .secondaryText
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        secondLabel = UILabel().then {
            
            $0.numberOfLines = 1
            $0.textColor = .primaryText
            $0.font = .systemFont(ofSize: 16, weight: .bold)
            $0.textAlignment = .center
        }
        
        let _ = UIStackView().then { stackView in
            
            stackView.addArrangedSubview(firstLabel)
            stackView.addArrangedSubview(secondLabel)
            stackView.axis = .vertical
            stackView.alignment = .fill
            
            addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
    }
    
}
