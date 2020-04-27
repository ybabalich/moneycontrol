//
//  HistoryTableHeaderView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 19.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class HistoryTableHeaderView: UITableViewHeaderFooterView {

    // MARK: - UI
    
    private var dayNumberLabel: UILabel!
    private var dayLabel: UILabel!
    private var monthLabel: UILabel!
    private var sumLabel: UILabel!
    
    // MARK: - Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("HistoryTableHeaderView")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public methods
    
    func apply(section: HistoryViewModel.Section) {
        dayNumberLabel.text = "\(section.date.dayNumber())"
        dayLabel.text = section.date.dayName()
        monthLabel.text = section.date.monthYearString()
        sumLabel.text = section.sum().currencyFormattedWithSymbol
    }
    
    // MARK: - Private methods
    
    private func setupUI() {

//        contentView.backgroundColor = .mainElementBackground
        tintColor = UIColor.controlTintActive.withAlphaComponent(0.1)
        
        dayNumberLabel = UILabel().then { dayNumberLabel in
         
            dayNumberLabel.font = .systemFont(ofSize: 35)
            dayNumberLabel.textColor = .primaryText
            
            contentView.addSubview(dayNumberLabel)
            dayNumberLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
            }
        }
        
        dayLabel = UILabel().then { dayLabel in
         
            dayLabel.font = .systemFont(ofSize: 12)
            dayLabel.textColor = .primaryText
            
            contentView.addSubview(dayLabel)
            dayLabel.snp.makeConstraints {
                $0.left.equalTo(dayNumberLabel.snp.right).offset(16)
                $0.top.equalTo(dayNumberLabel.snp.top).inset(6)
            }
        }
        
        monthLabel = UILabel().then { monthLabel in
         
            monthLabel.font = .systemFont(ofSize: 12)
            monthLabel.textColor = .primaryText
            
            contentView.addSubview(monthLabel)
            monthLabel.snp.makeConstraints {
                $0.left.equalTo(dayNumberLabel.snp.right).offset(16)
                $0.bottom.equalTo(dayNumberLabel.snp.bottom).inset(6)
            }
        }
        
        sumLabel = UILabel().then { sumLabel in
         
            sumLabel.font = .systemFont(ofSize: 14)
            sumLabel.textColor = .primaryText
            
            contentView.addSubview(sumLabel)
            sumLabel.snp.makeConstraints {
                $0.right.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
        }
        
    }
    
    
}
