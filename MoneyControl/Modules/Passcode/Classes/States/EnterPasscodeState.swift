//
//  EnterPasscodeState.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation
import UIKit.UIImage

class EnterPasscodeState: PasscodeLockStateType {

    let reachedMaximumAttemptsNotification =
        Notification(name: .init("EnterPasscodeState.ReachedMaximumAttemptsNotification"))

    let titleImage: UIImage?
    let title: String?
    let description: String?

    let isCancellableAction: Bool
    let areOptionsAvailable = false
    
    private var incorrectPasscodeAttempts = 0
    private var isNotificationSent = false
    private var lock: PasscodeLockType!
    
    init(allowCancellation: Bool = false) {
        isCancellableAction = allowCancellation

        titleImage = UIImage(named: "SplashIcon")
        title = nil //"PasscodePage.Enter.Title".localized
        description = nil //"PasscodePage.Enter.Subtitle".localized
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        self.lock = lock
        self.lock.repository.delegate = self
        self.lock.repository.verify(passcode: passcode)
    }
    
    private func postNotification() {
        
        guard !isNotificationSent else { return }

        isNotificationSent = true
        NotificationCenter.default.post(reachedMaximumAttemptsNotification)
    }
}

extension EnterPasscodeState: PasscodeRepositoryDelegate {

    func repositoryDidVerifyThePasscode(_ repository: PasscodeRepositoryType) {
        lock.delegate?.passcodeLockDidSucceed(lock: lock)
    }

    func repository(_ repository: PasscodeRepositoryType, didFailTheAttempt attemptsCount: Int) {

        incorrectPasscodeAttempts += 1
        lock.delegate?.passcodeLockDidFail(lock: lock, failedAttempts: attemptsCount)

        if incorrectPasscodeAttempts >= lock.configuration.maximumIncorrectPasscodeAttempts {
            postNotification()
        }
    }
}

