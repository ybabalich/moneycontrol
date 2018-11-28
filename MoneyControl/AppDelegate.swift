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


