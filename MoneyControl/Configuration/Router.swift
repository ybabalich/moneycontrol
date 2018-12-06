//
//  Router.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class Router {
    
    // MARK: - Variables
    var navigationViewController: UINavigationController!
    
    // MARK: - Class methods
    static let instance = Router()
    
    // MARK: - Public methods
    func goBack() {
        if let topController = navigationViewController.topViewController {
            if topController.presentedViewController != nil {
                topController.dismiss(animated: true, completion: nil)
                return
            } else {
                navigationViewController.popViewController(animated: true)
                return
            }
        }
        navigationViewController.popViewController(animated: true)
    }
    
    func showTodayHistoryScreen() {
        let todayHistoryFlow = AppLaunch.StoryboardFlow.activity(viewController: .todayHistory)
        showScreen(todayHistoryFlow, animated: true)
    }
    
    func showHistoryScreen() {
        let historyFlow = AppLaunch.StoryboardFlow.history(viewController: .base)
        showScreen(historyFlow, animated: true)
    }
    
    func showEditTransactionScreen(_ transaction: TransactionViewModel) {
        let editTransactionFlow = AppLaunch.StoryboardFlow.activity(viewController: .editTransaction)
        let transactionVC = showScreen(editTransactionFlow, animated: true) as! EditTransactionViewController
        transactionVC.transactionViewModel = transaction
    }
    
    // MARK: - Categories
    func showManageCategoriesScreen() {
        let manageCategoriesFlow = AppLaunch.StoryboardFlow.category(viewController: .manageCategories)
        showScreen(manageCategoriesFlow, animated: true)
    }

    
    // MARK: - Private methods
    @discardableResult
    private func showScreen(_ flowData: AppLaunch.StoryboardFlow, animated: Bool) -> UIViewController {
        let futureScreen = UIViewController.by(flow: flowData)
        if flowData.rawValue.isInitial {
            navigationViewController.setViewControllers([futureScreen], animated: animated)
        } else {
            navigationViewController.pushViewController(futureScreen, animated: animated)
        }
        return futureScreen
    }
    
    /*
     * Fetch controller in navigation view controller
     * and remove from array to avoid dublicate
     */
    private func fetchFlowIfExist(_ flow: AppLaunch.StoryboardFlow, remove: Bool) -> AppLaunch.StoryboardFlow? {
        let controllerName = flow.rawValue.controllerName
        var flowOfController: AppLaunch.StoryboardFlow?
        let viewControllers = navigationViewController.viewControllers.filter { (controller) -> Bool in
            if controllerName == String(describing: controller.classForCoder) {
                flowOfController = flow
                return remove ? false : true
            }
            return true
        }
        navigationViewController.setViewControllers(viewControllers, animated: false)
        
        return flowOfController
    }
    
}
