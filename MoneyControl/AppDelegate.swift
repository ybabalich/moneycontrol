//
//  AppDelegate.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/17/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit
import RealmSwift

var appLauncher: AppLaunch = AppLaunch()

@UIApplicationMain
class AppDelegate: UIResponder {

    // MARK: - Variables
    var window: UIWindow?
    
    // MARK: - Private methods
    fileprivate func setup(application: UIApplication,
                           launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        //controller for showing
        setupStoryboardForStart()
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                switch oldSchemaVersion {
                case 1:
                    break
                default:
                    migration.enumerateObjects(ofType: TransactionDB.className(), { (oldObject, newObject) in
                        newObject!["id"] = Int(Int(Date().timeIntervalSince1970) + Int.random(in: 0...1000000))
                    })
                }
        })
        
        Realm.Configuration.defaultConfiguration = config

        return true
    }
    
    fileprivate func setupStoryboardForStart() {
        let flowDataToShow = appLauncher.flowDataToShow()
        
        let controller = UIViewController.by(flow: flowDataToShow)
        let navigationController = UINavigationController(rootViewController: controller)
        Router.instance.navigationViewController = navigationController
        
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


