//
//  SettingsSectionViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 22.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class SettingsSectionViewModel {
    
    // MARK: - Public methods
    let title: String
    let needToShowArrow: Bool
    
    // MARK: - Initializers
    init(title: String, needToShowArrow: Bool) {
        self.title = title
        self.needToShowArrow = needToShowArrow
    }
    
    
}
