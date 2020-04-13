//
//  UISegmentedControl+MoneyControl.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    func applyStyle() {
        if #available(iOS 13, *) {
            selectedSegmentTintColor = .controlTintActive
            
            let unselectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryText];
            let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryText];
            
            setTitleTextAttributes(unselectedAttributes, for: .normal)
            setTitleTextAttributes(selectedAttributes, for: .selected)
        } else {
            tintColor = .controlTintActive
        }
    }
    
}
