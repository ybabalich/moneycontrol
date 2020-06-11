//
//  PasscodeSettings.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class PasscodeSettings {
    
    // MARK: - Variables public
    
    var isPINCodeProtected: Bool
    
    var passcode: String? {
        get {
            return "0000"
        }
        set {
            print("Set passcode \(newValue ?? "")")
        }
    }
    
    var passcodeMaximumFailAttempts: Int {
        return 3
    }
    
    // MARK: - Initializers
    
    init() {
        isPINCodeProtected = true
        subsribeToApplicationStateEvents()
    }
    
    // MARK: - Private methods
    
    private func subsribeToApplicationStateEvents() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(applicationDidEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func applicationDidEnterBackground(_ notification: Notification) {
//        appLoadedAfterBackground = true
        isPINCodeProtected = true
    }
    
}
