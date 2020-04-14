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

        accessoryType = .disclosureIndicator
        selectionStyle = .default

        textLabel?.textColor = .primaryText
        textLabel?.numberOfLines = 1
    }
    
    private func clearUI() {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            contentView.backgroundColor = UIColor.tableSeparator.withAlphaComponent(0.3)
        } else {
            contentView.backgroundColor = .white
        }
    }
    
}
