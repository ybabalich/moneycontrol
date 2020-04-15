//
//  InfoPreviewView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 15.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class InfoPreviewView: UIView {

    // MARK: - UI
    
    private var titleLabel: UILabel!
    private var balanceLabel: UILabel!
    
    private var oldFrame: CGRect = .zero
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if oldFrame != frame {
            applyFullyRounded(10)
            oldFrame = frame
        }
    }
    
    // MARK: - Public methods
    
    func apply(title: String, value: Double, color: UIColor) {
        titleLabel.text = title.uppercased()
        balanceLabel.text = value.currencyFormattedWithSymbol
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        backgroundColor = .mainElementBackground
        
        titleLabel = UILabel().then { entityLabel in
            
            entityLabel.font = .systemFont(ofSize: 14, weight: .regular)
            
            addSubview(entityLabel)
            entityLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.centerX.equalToSuperview()
            }
        }
        
        balanceLabel = UILabel().then { balanceLabel in
            
            balanceLabel.font = .systemFont(ofSize: 20, weight: .medium)
            balanceLabel.textAlignment = .center
            
            addSubview(balanceLabel)
            balanceLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
                $0.centerX.equalTo(titleLabel)
            }
        }
    }

}
