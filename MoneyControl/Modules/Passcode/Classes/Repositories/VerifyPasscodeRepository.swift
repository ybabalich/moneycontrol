//
//  VerifyPasscodeRepository.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation


class VerifyPasscodeRepository: PasscodeRepositoryType {

    weak var delegate: PasscodeRepositoryDelegate?

    var hasPasscode: Bool { Money.instance.settings.isPINCodeProtected }

    //
    
    func verify(passcode: [String]) {

        if passcode.joined() == Money.instance.settings.passcode {
            delegate?.repositoryDidVerifyThePasscode(self)
        } else {
//            delegate?.repository(self, didFailTheAttempt: pin.failedAttempts)
        }
    }
}

