//
//  PasscodeLockConfigurationType.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

public protocol PasscodeLockConfigurationType {
    
    var repository: PasscodeRepositoryType { get }
    
    var passcodeLength: Int { get }
    var maximumIncorrectPasscodeAttempts: Int { get }
}
