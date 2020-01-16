//
//  StringExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/17/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
