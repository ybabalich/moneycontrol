//
//  PasscodeRepositoryType.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

public protocol PasscodeRepositoryDelegate: class {
    func repositoryDidVerifyThePasscode(_ repository: PasscodeRepositoryType)
    func repository(_ repository: PasscodeRepositoryType, didFailTheAttempt attemptsCount: Int)
}

public protocol PasscodeRepositoryType: class {

    var delegate: PasscodeRepositoryDelegate? { get set }

    var hasPasscode: Bool { get }

    func verify(passcode: [String])
}
