//
//  BalancePreviewView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 15.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class BalancePreviewView: UIView {

    // MARK: - UI
    
    private var titleLabel: UILabel!
    private var dateLabel: UILabel!
    
    private var incomeView: InfoPreviewView!
    private var spentView: InfoPreviewView!
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    
    func apply(_ entity: Entity) {
        titleLabel.text = "Period".uppercased() //entity.title.uppercased()
        dateLabel.text = "15.04.2020 - 21.04.2020" //entity.balance.currencyFormattedWithSymbol
    }
    
    func showInfo(transactionType: Transaction.TransactionType, double: Double) {
        switch transactionType {
        case .incoming:
            incomeView.apply(title: transactionType.localizedTitle, value: double, color: .green)
        case .outcoming:
            spentView.apply(title: transactionType.localizedTitle, value: double, color: .red)
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        titleLabel = UILabel().then { titleLabel in
            
            titleLabel.font = .systemFont(ofSize: 19, weight: .regular)
            titleLabel.textAlignment = .left
            
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(22)
                $0.left.equalToSuperview().offset(8)
            }
        }
        
        dateLabel = UILabel().then { dateLabel in
            
            dateLabel.font = .systemFont(ofSize: 20, weight: .bold)
            dateLabel.textAlignment = .center
            
            addSubview(dateLabel)
            dateLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
            }
        }
        
        incomeView = InfoPreviewView().then { incomeView in

            incomeView.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width / 2 - 16)
                $0.height.equalTo(80)
            }
        }
        
        spentView = InfoPreviewView().then { spentView in
            
            spentView.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width / 2 - 16)
                $0.height.equalTo(80)
            }
        }
        
        let _ = UIStackView().then { stackView in
            
            stackView.addArrangedSubview(incomeView)
            stackView.addArrangedSubview(spentView)
            
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            
            addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom).offset(20)
                $0.left.right.equalToSuperview().inset(8)
                $0.bottom.equalToSuperview()
            }
        }
        
    }
}
