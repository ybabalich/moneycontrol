//
//  HistoryTopCollectionViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class HistoryTopCollectionViewCell: UICollectionViewCell {

    // MARK: - Outletes
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Private methods
    private func setup() {
        bottomView.layer.cornerRadius = bottomView.frame.height / 2
    }

}
