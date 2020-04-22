//
//  CategoryEditTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 20.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class CategoryEditTableViewCell: UITableViewCell {

    // MARK: - UI
    
    private var categoryImageView: UIImageView!
    private var titleLabel: UILabel!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CategoryEditTableViewCell")
    }
    
    // MARK: - Public methods
    
    func apply(category: CategoryViewModel) {
        categoryImageView.image = category.image
        titleLabel.text = category.title.capitalized
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        tintColor = .controlTintActive
        backgroundColor = .mainElementBackground
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        separatorInset = UIEdgeInsets(top: 0, left: 30 + 16 + 16, bottom: 0, right: 0)
        
        categoryImageView = UIImageView().then { categoryImageView in
            
            categoryImageView.applyFullyRounded(15)
            categoryImageView.backgroundColor = .red
            
            contentView.addSubview(categoryImageView)
            categoryImageView.snp.makeConstraints {
                $0.width.height.equalTo(30)
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
            }
        }
        
        titleLabel = UILabel().then { titleLabel in
            
            titleLabel.numberOfLines = 1
            titleLabel.text = "Cash"
            titleLabel.font = .systemFont(ofSize: 14)
            titleLabel.textColor = .primaryText
            
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.left.equalTo(categoryImageView.snp.right).offset(16)
                $0.centerY.equalTo(categoryImageView.snp.centerY)
            }
        }
    }
}
