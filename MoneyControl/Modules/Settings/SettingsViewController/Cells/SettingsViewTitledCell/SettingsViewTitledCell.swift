//
//  SettingsViewTitledCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 23.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsViewTitledCell: UITableViewCell {
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("SettingsViewTitledCell")
    }
    
    // MARK: - Lifecycle
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Public methods
    
    func apply(title: String) {
        textLabel?.text = title
    }
    
    // MARK: - Private methods
    
    private func setupUI() {

        selectedBackgroundView = UIView().then { $0.backgroundColor = UIColor.tableSeparator.withAlphaComponent(0.3) }
        
        accessoryType = .disclosureIndicator
        selectionStyle = .default

        textLabel?.textColor = .primaryText
        textLabel?.numberOfLines = 1

        backgroundColor = .mainElementBackground
    }
    
    private func clearUI() {
        
    }
    
}
