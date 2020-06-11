//
//  PasscodeLockType.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

public protocol PasscodeLockTypeDelegate: class {

    func passcodeLockDidSucceed(lock: PasscodeLockType)
    func passcodeLockDidFail(lock: PasscodeLockType, failedAttempts: Int)
    func passcodeLockDidChangeState(lock: PasscodeLockType)

    func passcodeLock(lock: PasscodeLockType, addedSignAtIndex index: Int)
    func passcodeLock(lock: PasscodeLockType, removedSignAtIndex index: Int)
}

public protocol PasscodeLockType: class {
    
    var delegate: PasscodeLockTypeDelegate? { get set }

    var configuration: PasscodeLockConfigurationType { get }
    var repository: PasscodeRepositoryType { get }
    var state: PasscodeLockStateType { get }
    
    func addSign(sign: String)
    func removeSign()
    func changeStateTo(state: PasscodeLockStateType)
}
