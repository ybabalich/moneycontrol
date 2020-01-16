//
//  ChooseCurrencyTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/17/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import UIKit

class ChooseCurrencyTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clear()
    }
    
    // MARK: - Public methods
    func apply(_ currency: Currency, isSelected: Bool) {
        flagImageView.image = UIImage(named: currency.flagName)
        titleLabel.text = currency.stringValue.uppercased() + " " + "(\(currency.symbol.uppercased()))"
        accessoryType = isSelected ? .checkmark : .none
    }
    
    // MARK: - Private methods
    private func clear() {
        flagImageView.image = nil
        titleLabel.text = nil
        accessoryType = .none
    }
    
}
