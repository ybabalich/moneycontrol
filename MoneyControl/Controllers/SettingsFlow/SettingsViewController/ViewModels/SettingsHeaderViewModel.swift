//
//  SettingsHeaderViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 22.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class SettingsHeaderViewModel {
    
    // MARK: - Public methods
    let id: Int
    let title: String
    
    // MARK: - Initializers
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
}
