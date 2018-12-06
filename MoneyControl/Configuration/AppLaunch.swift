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
        }
        
        enum History: String {
            case base = "HistoryViewController"
        }
        
        enum Category: String {
            case manageCategories = "ManageCategoriesViewController"
        }
        
        case activity(viewController: Activity)
        case history(viewController: History)
        case category(viewController: Category)
    }
    
    // MARK: - Public methods
    func flowDataToShow() -> StoryboardFlow {
        return .activity(viewController: .base)
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
        }
    }
}
