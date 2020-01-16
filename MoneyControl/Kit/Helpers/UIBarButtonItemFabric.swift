//
//  UIBarButtonItemFabric.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/24/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class UIBarButtonItemFabric {
    
    // MARK: - Private Class Methods
    private class func imagedBarButtonItem(imageName: String, size: CGSize) -> UIBarButtonItem {
        let bgI: UIImage? = UIImage(named: imageName)
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(bgI, for: .normal)
        button.tintColor = App.Color.main.rawValue
        
        if #available(iOS 11, *) {
            button.widthConstraint(needCreate: true)?.constant = size.width
            button.heightConstraint(needCreate: true)?.constant = size.height
        } else {
            button.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        
        return UIBarButtonItem(customView: button)
    }
    
    class func segmentBar(items: [Any]?) -> UIBarButtonItem {
        let segment = UISegmentedControl(items: items)
        segment.tintColor = App.Color.main.rawValue
        return UIBarButtonItem(customView: segment)
    }
    
    // MARK: - Public Class Methods
    class func titledBarButtonItem(title: String, fontSize: CGFloat = 28) -> UIBarButtonItem {
        let label: UILabel = UILabel()
        
        label.font = App.Font.main(size: fontSize, type: .bold).rawValue
        label.textColor = App.Color.main.rawValue
        label.text = title
        label.sizeToFit()
        
        return UIBarButtonItem(customView: label)
    }
    
    class func chartBarItem() -> UIBarButtonItem {
        return imagedBarButtonItem(imageName: "ic_chart", size: CGSize(width: 23, height: 20))
    }
    
    class func settingsBarItem() -> UIBarButtonItem {
        return imagedBarButtonItem(imageName: "ic_settings", size: CGSize(width: 23, height: 23))
    }
    
}
