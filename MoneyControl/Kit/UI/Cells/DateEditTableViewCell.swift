//
//  DateEditTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 20.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class DateEditTableViewCell: UITableViewCell {

    // MARK: - UI
    
    private var titleLabel: UILabel!
    private var textField: UITextField!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("DateEditTableViewCell")
    }
    
    // MARK: - Public methods
    
    func getDateField() -> UITextField {
        return textField
    }
    
    func apply(date: String) {
        titleLabel.text = date
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        tintColor = .controlTintActive
        backgroundColor = .mainElementBackground
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        separatorInset = UIEdgeInsets(top: 0, left: 30 + 16 + 16, bottom: 0, right: 0)
        
        textField = UITextField().then { textField in
            
            contentView.addSubview(textField)
            textField.snp.makeConstraints {
                $0.width.height.equalTo(CGSize(width: 0, height: 0))
                $0.left.top.equalToSuperview()
            }
        }
        
        titleLabel = UILabel().then { titleLabel in
            
            titleLabel.numberOfLines = 1
            titleLabel.text = "21.04.2020"
            titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
            titleLabel.textColor = .primaryText
            
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
