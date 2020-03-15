//
//  UIColor+Assets.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 07.03.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit.UIColor

extension UIColor {

    static var barBackground: UIColor {
        return .assetColor(named: #function)
    }
    
    static var mainBackground: UIColor {
        return .assetColor(named: #function)
    }
    
    static var primaryText: UIColor {
        return .assetColor(named: #function)
    }
    
    static var mainElementBackground: UIColor {
        return .assetColor(named: #function)
    }
    
    static var controlTintActive: UIColor {
        return .assetColor(named: #function)
    }
    
    static var tableSeparator: UIColor {
        return .assetColor(named: #function)
    }
    
    static var secondaryText: UIColor {
        return .assetColor(named: #function)
    }

}

private extension UIColor {

    static func assetColor(named name: String) -> UIColor {

        guard let retVal = UIColor(named: name) else {
            fatalError("Color named \(name) does not exist!")
        }

        return retVal
    }
}

