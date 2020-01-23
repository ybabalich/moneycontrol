//
//  SettingsViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 22.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    // MARK: - Public methods
    var headers: [SettingsHeaderViewModel] = []
    var sections: [Int: [SettingsSectionViewModel]] = [:]
    
    // MARK: - Initializers
    init() {
        setup()
    }
    
    // MARK: - Public methods
    func headersCount() -> Int {
        return headers.count
    }
    
    func rowsCount(for section: Int) -> Int {
        return sections[section]?.count ?? 0
    }
    
    func row(at section: Int, for index: Int) -> SettingsSectionViewModel {
        return sections[section]![index]
    }
    
    func header(at index: Int) -> SettingsHeaderViewModel {
        return headers[index]
    }
    
    // MARK: - Private methods
    private func setup() {
        //headers
        let general = SettingsHeaderViewModel(id: 0, title: "General")
        let feedback = SettingsHeaderViewModel(id: 1, title: "Feedback")
        
        headers = [general, feedback]
        
        //sections
        
        //general
        let generalSections = [SettingsSectionViewModel(title: "Change currency", needToShowArrow: true),
                               SettingsSectionViewModel(title: "Change language", needToShowArrow: true)]
        sections[general.id] = generalSections
        
        //feedback
        let feedbackSections = [SettingsSectionViewModel(title: "Leave feedback", needToShowArrow: false),
                                SettingsSectionViewModel(title: "Write to Developers", needToShowArrow: false)]
        sections[feedback.id] = feedbackSections
    }
    
}
