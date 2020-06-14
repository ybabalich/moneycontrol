//
//  UpdatePasscodeRepository.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class UpdatePasscodeRepository: PasscodeRepositoryType {

    weak var delegate: PasscodeRepositoryDelegate?

    var hasPasscode: Bool { true }

    //

    func verify(passcode: [String]) {
        let pincodeString = passcode.joined()
        Money.instance.settings.passcode = pincodeString
        
        delegate?.repositoryDidVerifyThePasscode(self)
        
//        delegate?.repository(self, didFailTheAttempt: 0)
    }
}
