//
//  SettingsViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 22.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    struct Row {
        
        let title: String
    }
    
    struct Section {
        
        let title: String?
        let rows: [Row]
    }
    
    // MARK: - Variables public
    
    var sections: [Section] = []
    
    // MARK: - Public methods
    
    func loadData() {
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        
        sections = [
            Section(title: "General".localized,
                    rows: [Row(title: "Change currency".localized),
                           Row(title: "Change language".localized)]),
            
            Section(title: "settings.tabs.header.title.privacyAndSecurity".localized,
                    rows: [Row(title: "settings.tab.title.pinCode".localized)]),
            
            Section(title: "Feedback".localized,
                    rows: [Row(title: "Leave feedback".localized),
                           Row(title: "Write to Developers".localized)])
        ]
    }
    
}
