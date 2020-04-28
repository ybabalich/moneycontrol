//
//  AppDelegate.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/17/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

var db = try! Realm()
var appLauncher: AppLaunch = AppLaunch()
var settings = Settings()

@UIApplicationMain
class AppDelegate: UIResponder {

    // MARK: - Variables
    var window: UIWindow?
    
    // MARK: - Private methods
    fileprivate func setup(application: UIApplication,
                           launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        settings.launchCount += 1
        
        //controller for showing
        
        setupStoryboardForStart()
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 4,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                switch oldSchemaVersion {
                case 4:
                    migration.enumerateObjects(ofType: TransactionDB.className(), { (oldObject, newObject) in
                        newObject!["entity"] = nil
                    })
                default: print("Exception")
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        // TODO: need to remove and apply better logic for old users
        if !settings.baseCategoriesAdded { // first time launch
            CategoryService.instance.saveBaseCategories()
            
            settings.baseCategoriesAdded = true
        }
        
        if settings.firstTimeEnterWithWallets {
            WalletsService.instance.saveFirstTimeWallets()
            
            if let currentEntity = WalletsService.instance.fetchCurrentWallet() {
                let transactions = TransactionService.instance.fetchAllTransactions()
                
                transactions.forEach { transaction in
                    transaction.entity = currentEntity
                    TransactionService.instance.update(transaction)
                }
            }
            
            settings.firstTimeEnterWithWallets = false
        }
        
        FirebaseApp.configure()
        
        return true
    }
    
    fileprivate func setupStoryboardForStart() {
        let flowDataToShow = appLauncher.flowDataToShow()

        let controller = UIViewController.by(flow: flowDataToShow)
        let navigationController = UINavigationController(rootViewController: controller)
        
        navigationController.navigationBar.applyMainBackground()
        navigationController.navigationBar.applyTitleStyle()
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type])
            .setTitleTextAttributes([NSAttributedString.Key.font: App.Font.main(size: 17, type: .light).rawValue,
                                     NSAttributedString.Key.foregroundColor: UIColor.primaryText], for: .normal)
        
        Router.instance.navigationViewController = navigationController
        Router.instance.navigationViewController.isNavigationBarHidden = flowDataToShow == .activity(viewController: .chooseCurrency)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        return setup(application: application, launchOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}


