//
//  ChooseCategoryTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/20/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import UIKit

class ChooseCategoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    // MARK: - Public methods
    func apply(_ viewModel: CategoryViewModel, isSelected: Bool) {
        categoryImageView.image = viewModel.image
        categoryTitle.text = viewModel.title
        accessoryType = isSelected ? .checkmark : .none
    }
    
    // MARK: - Private methods
    private func setup() {
        
        // colors
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        categoryTitle.textColor = .primaryText
    }
    
}
