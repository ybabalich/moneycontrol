//
//  UINavigationBarExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 18.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func applyMainBackground() {
        barTintColor = .barBackground
        isTranslucent = false
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
    
    func applyClearBackground() {
        barTintColor = .clear
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
    
    func applyTitleStyle() {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.primaryText,
                                                         .font: App.Font.main(size: 16, type: .bold).rawValue]
        
        titleTextAttributes = attributes
    }
    
}

