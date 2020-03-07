//
//  ManagedCategoryTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/3/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class ManagedCategoryTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var eyeSwitchView: EyeSwitchView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    // MARK: - Public methods
    func apply(_ viewModel: CategoryViewModel) {
        categoryImageView.image = viewModel.image
        categoryTitle.text = viewModel.title
        eyeSwitchView.isActive = true
    }
    
    // MARK: - Private methods
    private func setup() {
        
    }
    
}
