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
    func show(sortEntity: SortEntity) {
        
        //titles
        
        firstLabel.text = sortEntity.stringValue.uppercased()
        
        switch sortEntity {
        case .total: break
//            secondLabel.text = balance.currencyFormattedWithSymbol
            
        case .wallet(entity: let entity):
            secondLabel.text = entity.balance.currencyFormattedWithSymbol
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        firstLabel = UILabel().then {
            
            $0.numberOfLines = 1
            $0.textColor = .secondaryText
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.sizeToFit()
        }
        
        secondLabel = UILabel().then {
            
            $0.numberOfLines = 1
            $0.textColor = .primaryText
            $0.font = .systemFont(ofSize: 16, weight: .bold)
            $0.textAlignment = .center
            $0.sizeToFit()
        }
        
        let _ = UIStackView().then { stackView in
            
            stackView.addArrangedSubview(firstLabel)
            stackView.addArrangedSubview(secondLabel)
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.sizeToFit()
            
            addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
