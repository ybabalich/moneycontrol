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
    
    private var dateSetView: DateSetView!
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    
    func apply(sort: Sort) {
        let dates = sort.startEndDate
        dateLabel.text = "\(dates.start.shortString) - \(dates.end.shortString)"
        
        dateSetView.apply(title: sort.stringValue.uppercased())
    }
    
    func showInfo(transactionType: Transaction.TransactionType, double: Double) {
        switch transactionType {
        case .incoming:
            incomeView.backgroundColor = UIColor.income.withAlphaComponent(0.7)
            incomeView.apply(title: transactionType.localizedTitle, value: double, color: .green)
        case .outcoming:
            spentView.backgroundColor = UIColor.outcome.withAlphaComponent(0.7)
            spentView.apply(title: transactionType.localizedTitle, value: double, color: .red)
        }
    }
    
    func onTapChooseSort(completion: @escaping EmptyClosure) {
        dateSetView.onTap(completion: completion)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        dateSetView = DateSetView().then { dateSetView in
            
            dateSetView.apply(title: "Today")
            
            addSubview(dateSetView)
            dateSetView.snp.makeConstraints {
                $0.right.equalToSuperview().inset(8)
                $0.top.equalToSuperview().offset(12)
            }
        }
        
        dateLabel = UILabel().then { dateLabel in
            
            dateLabel.font = .systemFont(ofSize: UIScreen.isSmallDevice ? 15 : 19, weight: .bold)
            dateLabel.textAlignment = .left
            dateLabel.textColor = .primaryText
            
            addSubview(dateLabel)
            dateLabel.snp.makeConstraints {
                $0.centerY.equalTo(dateSetView)
                $0.left.equalToSuperview().offset(8)
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
