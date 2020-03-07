//
//  SettingsSectionViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 22.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class SettingsSectionViewModel {
    
    enum SectionType: Int {
        case changeLanguage
        case changeCurrency
        case leaveFeedback
        case writeToDevelopers
    }
    
    // MARK: - Public methods
    let type: SectionType
    let title: String
    let needToShowArrow: Bool
    
    // MARK: - Initializers
    init(type: SectionType, title: String, needToShowArrow: Bool) {
        self.type = type
        self.title = title
        self.needToShowArrow = needToShowArrow
    }
    
    
}
