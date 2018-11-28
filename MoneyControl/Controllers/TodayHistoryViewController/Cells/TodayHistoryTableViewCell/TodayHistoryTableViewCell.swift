//
//  TodayHistoryTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class TodayHistoryTableViewCell : UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Public methods
    func apply(_ viewModel: TransactionViewModel) {
        categoryImageView.image = viewModel.category.image
        valueLabel.text = "\(viewModel.value)"
        valueLabel.textColor = viewModel.type == .incoming ? App.Color.incoming.rawValue : App.Color.outcoming.rawValue
        categoryNameLabel.text = viewModel.category.title
    }
    
}
