//
//  Int+MoneyControl.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 27.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

extension Int {
    
    static func generateID() -> Int {
        Int(Date().timeIntervalSince1970) + Int.random(in: 0...100_000_000)
    }
    
}
