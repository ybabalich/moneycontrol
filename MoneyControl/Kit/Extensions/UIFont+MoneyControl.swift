//
//  UIFont+MoneyControl.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit.UIFont

extension UIFont {

    static func systemRoundedFont(ofSize size: CGFloat, weight: Weight) -> UIFont {

        // Will be SF Compact or standard SF in case of failure.
        let defaultFont = systemFont(ofSize: size, weight: weight)

        guard #available(iOS 13, *) else { return defaultFont }
        guard let descriptor = defaultFont.fontDescriptor.withDesign(.rounded) else { return defaultFont }

        return UIFont(descriptor: descriptor, size: size)
    }
}
