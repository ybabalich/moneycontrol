//
//  AppLaunch.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

class AppLaunch {
    
    enum StoryboardFlow: Equatable {
        
        struct StoryboardFlowData {
            // MARK: - Variables
            let storyboardName: String
            let controllerName: String?
            let isInitial: Bool
            
            // MARK: - Initialization methods
            init(storyboardName: String, controllerName: String?, isInitial: Bool) {
                self.storyboardName = storyboardName
                self.controllerName = controllerName
                self.isInitial = isInitial
            }
            
            init(storyboardName: String, isInitial: Bool) {
                self.storyboardName = storyboardName
                self.controllerName = nil
                self.isInitial = isInitial
            }
        }
        
        enum Activity: String {
            case base = "ActivityViewController"
            case todayHistory = "TodayHistoryViewController"
            case editTransaction = "EditTransactionViewController"
            case chooseCurrency = "ChooseCurrencyViewController"
            case yourBalance = "YourBalanceViewController"
        }
        
        enum History: String {
            case base = "HistoryViewController"
            case transactionsList = "TransactionsHistoryListViewController"
        }
        
        enum Category: String {
            case manageCategories = "ManageCategoriesViewController"
            case chooseCategory = "ChooseCategoryViewController"
        }
        
        enum Settings: String {
            case base = "SettingsViewController"
            case changeLanguage = "SettingsChooseLanguageViewController"
        }
        
        case activity(viewController: Activity)
        case history(viewController: History)
        case category(viewController: Category)
        case settings(viewController: Settings)
    }
    
    // MARK: - Public methods
    func flowDataToShow() -> StoryboardFlow {
        if let _ = settings.currency {
            return .activity(viewController: .base)
        } else {
            return .activity(viewController: .chooseCurrency)
        }
    }
}

extension AppLaunch.StoryboardFlow {
    // MARK: - Variables
    var rawValue: StoryboardFlowData {
        switch self {
        case .activity(viewController: let controller):
            return StoryboardFlowData(storyboardName: "ActivityFlow",
                                      controllerName: controller.rawValue,
                                      isInitial: controller == .base ? true : false)
        case .history(viewController: let controller):
            return StoryboardFlowData(storyboardName: "HistoryFlow",
                                      controllerName: controller.rawValue,
                                      isInitial: false)
        case .category(viewController: let controller):
            return StoryboardFlowData(storyboardName: "CategoryFlow",
                                      controllerName: controller.rawValue,
                                      isInitial: false)
        case .settings(viewController: let controller):
        return StoryboardFlowData(storyboardName: "SettingsFlow",
                                  controllerName: controller.rawValue,
                                  isInitial: false)
        }
    }
}
