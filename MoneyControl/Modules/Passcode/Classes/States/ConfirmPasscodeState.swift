//
//  ConfirmPasscodeState.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation
import UIKit.UIImage

class ConfirmPasscodeState: PasscodeLockStateType {
    
    let titleImage: UIImage?
    let title: String?
    let description: String?
    
    let isCancellableAction = false
    let areOptionsAvailable = false
    
    private var passcodeToConfirm: [String]
    private var lock: PasscodeLockType!

    init(passcode: [String], title: String? = nil, description: String? = nil) {
        passcodeToConfirm = passcode

        self.titleImage = nil
        self.title = title ?? "PasscodePage.Confirm.Title".localized
        self.description = description ?? "PasscodePage.Confirm.Subtitle".localized
    }

    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        self.lock = lock
        self.lock.repository.delegate = self

        if passcode == passcodeToConfirm {
            lock.repository.verify(passcode: passcode)
        } else {
            repository(self.lock.repository, didFailTheAttempt: 0)
        }
    }
}

extension ConfirmPasscodeState: PasscodeRepositoryDelegate {

    func repositoryDidVerifyThePasscode(_ repository: PasscodeRepositoryType) {
        lock.delegate?.passcodeLockDidSucceed(lock: lock)
    }

    func repository(_ repository: PasscodeRepositoryType, didFailTheAttempt attemptsCount: Int) {

        lock.delegate?.passcodeLockDidFail(lock: lock, failedAttempts: attemptsCount)

        let newState = ConfirmPasscodeState(
            passcode: passcodeToConfirm,
            description: "PasscodePage.Confirm.MissmatchSubtitle".localized
        )

        lock.changeStateTo(state: newState)
    }
}

