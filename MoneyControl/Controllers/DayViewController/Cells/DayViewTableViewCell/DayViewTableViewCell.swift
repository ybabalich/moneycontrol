//
//  DayViewTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class DayViewTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    // MARK: - Variables
    static let cellIdentifier = "DayViewTableViewCell"
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    // MARK: - Public methods
    func configure(_ money: Money) {
        topLabel.text = money.category.title
        bottomLabel.text = money.entity.value
        
        if money.type == .incoming {
            rightLabel.textColor = .green
        } else  {
            rightLabel.textColor = .red
        }
        
        rightLabel.text = String(money.value)
    }
    
    // MARK: - Private methods
    private func clearCell() {
        categoryImage.image = nil
        topLabel.text = nil
        bottomLabel.text = nil
    }
    
}
