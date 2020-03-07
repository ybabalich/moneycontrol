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
    
    // MARK: - Public methods
    func headersCount() -> Int {
        return headers.count
    }
    
    func rowsCount(for section: Int) -> Int {
        return sections[section]?.count ?? 0
    }
    
    func viewModelForRow(at section: Int, for index: Int) -> SettingsSectionViewModel {
        return sections[section]![index]
    }
    
    func header(at index: Int) -> SettingsHeaderViewModel {
        return headers[index]
    }
    
    func loadData() {
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        //headers
        let general = SettingsHeaderViewModel(id: 0, title: "General".localized)
        let feedback = SettingsHeaderViewModel(id: 1, title: "Feedback".localized)
        
        headers = [general, feedback]
        
        //sections
        
        //general
        let generalSections = [SettingsSectionViewModel(type: .changeCurrency, title: "Change currency".localized, needToShowArrow: true),
                               SettingsSectionViewModel(type: .changeLanguage, title: "Change language".localized, needToShowArrow: true)]
        sections[general.id] = generalSections
        
        //feedback
        let feedbackSections = [SettingsSectionViewModel(type: .leaveFeedback, title: "Leave feedback".localized, needToShowArrow: false),
                                SettingsSectionViewModel(type: .writeToDevelopers, title: "Write to Developers".localized, needToShowArrow: false)]
        sections[feedback.id] = feedbackSections
    }
    
}
