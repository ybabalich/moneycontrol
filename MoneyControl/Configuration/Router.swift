//
//  Router.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    // MARK: - Variables
    var navigationViewController: UINavigationController! {
        didSet {
            navigationViewController.delegate = self
        }
    }
    var secondaryNavigationViewController: UINavigationController?
    var lastPushedScreen: UIViewController?
    var lastPresentedScreen: UIViewController?
    
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
    
    func showController(_ controller: UIViewController, animated: Bool = true) {
        navigationViewController.pushViewController(controller, animated: animated)
    }
    
    func showActivityScreen() {
        Router.instance.navigationViewController.isNavigationBarHidden = false
        let activityScreen = AppLaunch.StoryboardFlow.activity(viewController: .base)
        showScreen(activityScreen, animated: true)
    }
    
    func showTodayHistoryScreen() {
        let todayHistoryFlow = AppLaunch.StoryboardFlow.activity(viewController: .todayHistory)
        showScreen(todayHistoryFlow, animated: true)
    }
    
    func showHistoryScreen() {
        let historyFlow = AppLaunch.StoryboardFlow.history(viewController: .base)
        showScreen(historyFlow, animated: true)
    }
    
    func showTransactionsList(_ historyVM: HistoryViewModel) {
        let transactionsList = AppLaunch.StoryboardFlow.history(viewController: .transactionsList)
        let transactionsVC = showScreen(transactionsList, animated: true) as! TransactionsHistoryListViewController
        transactionsVC.historyViewModel = historyVM
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
    
    func showChooseCategoryScreen() {
        let chooseCategoryFlow = AppLaunch.StoryboardFlow.category(viewController: .chooseCategory)
        showScreen(chooseCategoryFlow, animated: true)
    }
    
    // MARK: - Settings
    func showSettingsScreen() {
        let settingsFlow = AppLaunch.StoryboardFlow.settings(viewController: .base)
        showScreen(settingsFlow, animated: true)
    }
    
    //startup screens
    func showYourBalanceScreen() {
        let yourBalanceScreen = AppLaunch.StoryboardFlow.activity(viewController: .yourBalance)
        showScreen(yourBalanceScreen, animated: true)
    }
    
    //general
    @discardableResult
    func goBackToController<T>(type: T.Type) -> T? {
        lastPushedScreen = nil
        
        let navigation: UINavigationController = secondaryNavigationViewController != nil ? secondaryNavigationViewController! : navigationViewController
        
        var searchController: T?
        
        if let presentedViewController = navigation.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
        
        navigation.viewControllers.forEach { (controller) in
            if controller.classForCoder == type {
                searchController = controller as? T
            }
        }
        
        if let searchController = searchController {
            let navViewControllers = navigation.viewControllers
            let newViewControllers = Array(navViewControllers[0...navViewControllers.firstIndex(of: searchController as! UIViewController)!])
            navigation.setViewControllers(newViewControllers, animated: true)
        }
        
        return searchController
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

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool)
    {
        let backButton = UIBarButtonItem(
            title: "Back".localized,
            style: .done,
            target: nil,
            action: nil
        )
        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
