//
//  PasscodeLock.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation
//import LocalAuthentication

public class PasscodeLock: PasscodeLockType {

    //
    // MARK: Public Accessors
    
    public weak var delegate: PasscodeLockTypeDelegate?
    public let configuration: PasscodeLockConfigurationType
    
    public var repository: PasscodeRepositoryType { configuration.repository }
    public var state: PasscodeLockStateType { lockState }

    //
    // MARK: - Private Stuff

    private var lockState: PasscodeLockStateType
    private lazy var passcode = [String]()

    private func handleTouchIDResult(success: Bool) {

        DispatchQueue.main.async {
            guard success else { return }
            self.delegate?.passcodeLockDidSucceed(lock: self)
        }
    }

    //
    // MARK: - Object Lifecycle
    
    public init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType) {
        
        precondition(configuration.passcodeLength > 0, "Passcode length sould be greather than zero.")
        
        self.lockState = state
        self.configuration = configuration
    }
    
    public func addSign(sign: String) {
        
        passcode.append(sign)
        delegate?.passcodeLock(lock: self, addedSignAtIndex: passcode.count - 1)
        
        if passcode.count >= configuration.passcodeLength {
            lockState.acceptPasscode(passcode: passcode, fromLock: self)
            passcode.removeAll(keepingCapacity: true)
        }
    }
    
    public func removeSign() {
        
        guard passcode.isEmpty == false else { return }
        
        passcode.removeLast()
        delegate?.passcodeLock(lock: self, removedSignAtIndex: passcode.count)
    }
    
    public func changeStateTo(state: PasscodeLockStateType) {
        lockState = state
        delegate?.passcodeLockDidChangeState(lock: self)
    }
}
