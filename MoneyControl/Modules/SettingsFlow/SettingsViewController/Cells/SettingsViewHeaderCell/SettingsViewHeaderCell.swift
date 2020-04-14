//
//  SettingsViewHeaderCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 22.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsViewHeaderCell: UITableViewHeaderFooterView {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    override var reuseIdentifier: String? {
        return "SettingsViewHeaderCell"
    }
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // MARK: - Lifecyle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearUI()
    }
    
    // MARK: - Public methods
    func apply() {
        
    }
    
    // MARK: - Private methods
    private func setupUI() {
        
    }
    
    private func clearUI() {
        
    }

}
