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
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0xFFFFFF)
        }
    }
    
    static var mainBackground: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0xDCF5FB)
        }
    }
    
    static var primaryText: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0x2A5077)
        }
    }
    
    static var mainElementBackground: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0xFFFFFF)
        }
    }
    
    static var controlTintActive: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0xF5C699)
        }
    }
    
    static var controlTintGreen: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0x27AE60)
        }
    }
    
    static var controlTintDestructive: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0xE74C3C)
        }
    }

    static var tableSeparator: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0xF5C699).withAlphaComponent(0.5)
        }
    }
    
    static var secondaryText: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0x2A5093)
        }
    }
    
    static var walletPlaceholderBackground: UIColor {
        if #available(iOS 11.0, *) {
            return .assetColor(named: #function)
        } else {
            return UIColor(hex: 0xbadc58)
        }
    }
}

private extension UIColor {

    static func assetColor(named name: String) -> UIColor {

        if #available(iOS 11.0, *) {
            guard let retVal = UIColor(named: name) else {
                fatalError("Color named \(name) does not exist!")
            }
            
            return retVal
        }
        
        return .clear
    }
}

