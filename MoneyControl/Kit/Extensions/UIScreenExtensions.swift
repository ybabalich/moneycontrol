//
//  UIScreenExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/17/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import UIKit

extension UIScreen {
    
    class var isSmallDevice: Bool {
        return UIScreen.main.bounds.height < 667
    }
    
}
