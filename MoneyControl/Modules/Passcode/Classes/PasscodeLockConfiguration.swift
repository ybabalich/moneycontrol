//
//  PasscodeLockConfiguration.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

class PasscodeLockConfiguration: PasscodeLockConfigurationType {
    
    let repository: PasscodeRepositoryType

    let passcodeLength: Int
    let maximumIncorrectPasscodeAttempts: Int
    
    init(repository: PasscodeRepositoryType = VerifyPasscodeRepository(),
         passcodeLength: Int = 4,
         maximumInccorectPasscodeAttempts: Int = -1
    ) {
        self.repository = repository

        self.passcodeLength = passcodeLength
        self.maximumIncorrectPasscodeAttempts = maximumInccorectPasscodeAttempts
    }
}
