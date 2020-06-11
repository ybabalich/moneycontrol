//
//  SetPasscodeState.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation
import UIKit.UIImage

class SetPasscodeState: PasscodeLockStateType {
    
    let titleImage: UIImage?
    let title: String?
    let description: String?
    
    let isCancellableAction = false
    let areOptionsAvailable = true
    
    init(title: String, description: String) {
        self.titleImage = nil
        self.title = title
        self.description = description
    }
    
    init() {
        titleImage = nil
        title = "PasscodePage.Set.Title".localized
        description = "PasscodePage.Set.Subtitle".localized
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        let nextState = ConfirmPasscodeState(passcode: passcode)
        lock.changeStateTo(state: nextState)
    }
}

extension SetPasscodeState: PasscodeRepositoryDelegate {

    func repositoryDidVerifyThePasscode(_ repository: PasscodeRepositoryType) { }
    func repository(_ repository: PasscodeRepositoryType, didFailTheAttempt attemptsCount: Int) { }
}
