//
//  AppCoordinator.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 30.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    //
    // MARK: - Private Stuff

    private let blurCoordinator: BlurCoordinator
    private let mainFlowCoordinator: MainFlowCoordinator
    private let passcodeCoordinator: PasscodeCoordinator
    
    private let contentWindow: UIWindow
    
    
    //
    // MARK: - Object Lifecycle
    
    init() {

        defer {
            blurCoordinator.delegate = self
            mainFlowCoordinator.delegate = self
        }

        do {
            contentWindow = UIWindow(frame: UIScreen.main.bounds)
            contentWindow.windowLevel = .normal

            mainFlowCoordinator = MainFlowCoordinator(window: contentWindow)
        }

        do {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.windowLevel = .init(UIWindow.Level.alert.rawValue + 1)
            window.backgroundColor = .clear

            blurCoordinator = BlurCoordinator(window: window)
        }
        
        do {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.windowLevel = .init(UIWindow.Level.alert.rawValue + 3)
            window.backgroundColor = .clear

            passcodeCoordinator = PasscodeCoordinator(window: window)
        }
    }
    
    // MARK: - Public methods
    
    func start() {
        
        /*if Money.instance.settings.isPINCodeProtected {
            
            print("*Flow: Protected with a PIN*")
            
            showPasscodeCoordinator()
            return
        }*/
        
        mainFlowCoordinator.start()
    }
    
}

extension AppCoordinator {
    
    func showPasscodeCoordinator() {
        
        passcodeCoordinator.whenConfirmed = { [unowned self] in
            Money.instance.settings.isPINCodeProtected = false
            self.start()
        }
        
        passcodeCoordinator.start(length: 4)
    }
    
}

extension AppCoordinator: CoordinatorDelegate {
    func coordinatorDidStart(_ coordinator: Coordinator) {
        
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
    
    }
}
