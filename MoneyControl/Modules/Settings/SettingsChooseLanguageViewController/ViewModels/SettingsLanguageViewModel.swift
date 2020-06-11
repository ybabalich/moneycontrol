//
//  SettingsLanguageViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 23.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class SettingsLanguageViewModel {
    
    // MARK: - Variables public
    let id: Int
    let title: String
    let iconName: String
    let languageCode: String
    var isSelected: Bool = false
    
    // MARK: - Initializers
    init(id: Int, title: String, iconName: String, languageCode: String) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.languageCode = languageCode
    }
    
}
