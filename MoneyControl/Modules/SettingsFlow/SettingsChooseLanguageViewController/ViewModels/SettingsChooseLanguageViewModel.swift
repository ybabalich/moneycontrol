//
//  SettingsChooseLanguageViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 23.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import RxSwift
import RxCocoa

class SettingsChooseLanguageViewModel {
    
    // MARK: - Varaibles private
    let success = PublishSubject<Bool>()
    let languages = BehaviorRelay<[SettingsLanguageViewModel]>(value: [])
    
    // MARK: - Public methods
    func loadData() {
        let uk = SettingsLanguageViewModel(id: 0, title: "Ukraine", iconName: "ic_flag_uah", languageCode: "uk")
        let en = SettingsLanguageViewModel(id: 0, title: "English", iconName: "ic_flag_usd", languageCode: "en")
        let ru = SettingsLanguageViewModel(id: 0, title: "Russian", iconName: "ic_flag_rub", languageCode: "ru")
        
        let languages = [uk, en, ru].map { (viewModel) -> SettingsLanguageViewModel in
            viewModel.isSelected = (viewModel.languageCode == LocalizationService.instance.preferredLanguage())
            return viewModel
        }
        
        self.languages.accept(languages)
    }
    
    func setLanguageCode(_ langaugeCode: String) {
        settings.languageCode = langaugeCode
        success.onNext(true)
    }
    
    func sectionsCount() -> Int {
        return languages.value.count
    }
    
    func viewModel(for row: Int) -> SettingsLanguageViewModel {
        return languages.value[row]
    }
    
}
