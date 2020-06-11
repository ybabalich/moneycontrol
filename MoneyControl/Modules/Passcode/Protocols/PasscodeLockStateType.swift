//
//  PasscodeLockStateType.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation
import UIKit.UIImage

public protocol PasscodeLockStateType: PasscodeRepositoryDelegate {

    var titleImage: UIImage? { get }
    var title: String? { get }
    var description: String? { get }

    var isCancellableAction: Bool { get }
    var areOptionsAvailable: Bool { get }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType)
}
