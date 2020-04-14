//
//  SettingsChooseLanguageTitledCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 23.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsChooseLanguageTitledCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clear()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clear()
    }
    
    // MARK: - Public methods
    func apply(_ viewModel: SettingsLanguageViewModel) {
        flagImageView.image = UIImage(named: viewModel.iconName)
        titleLabel.text = viewModel.title
        accessoryType = viewModel.isSelected ? .checkmark : .none
    }
    
    // MARK: - Private methods
    private func clear() {
        flagImageView.image = nil
        titleLabel.text = nil
        accessoryType = .none
    }
    
}
