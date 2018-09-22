//
//  UIWindowExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/22/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

extension UIWindow {
    
    var topSafeInset: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaInsets.top
        }
        return 0
    }
    
    var bottomSafeInset: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaInsets.bottom
        }
        return 0
    }
    
}
