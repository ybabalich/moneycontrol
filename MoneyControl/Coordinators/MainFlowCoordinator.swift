//
//  MainFlowCoordinator.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 02.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class MainFlowCoordinator: Coordinator {
    
    // MARK: - Variables private
    
    private let window: UIWindow
    
    // MARK: - Initializer
    
    init(window: UIWindow) {
        self.window = window

        
    }
    
    // MARK: - Public methods
    
    override func start() {

        guard !isPresented else {
            return
        }
        super.start()

        //
        
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
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    override func finish() {
        guard isPresented else { return }
        super.finish()
    }
    
}
