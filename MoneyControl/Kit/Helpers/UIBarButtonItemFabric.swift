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
    private class func imagedBarButtonItem(imageName: String) -> UIBarButtonItem {
        let bgI: UIImage? = UIImage(named: imageName)
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(bgI, for: .normal)
        button.tintColor = App.Color.main.rawValue
        button.widthConstraint(needCreate: true)?.constant = 23
        button.heightConstraint(needCreate: true)?.constant = 20
        
        return UIBarButtonItem(customView: button)
    }
    
    class func segmentBar(items: [Any]?) -> UIBarButtonItem {
        let segment = UISegmentedControl(items: items)
        segment.tintColor = App.Color.main.rawValue
        return UIBarButtonItem(customView: segment)
    }
    
    // MARK: - Public Class Methods
    class func titledBarButtonItem(title: String) -> UIBarButtonItem {
        let label: UILabel = UILabel()
        
        label.font = App.Font.main(size: 28, type: .bold).rawValue
        label.textColor = App.Color.main.rawValue
        label.text = title
        label.sizeToFit()
        
        return UIBarButtonItem(customView: label)
    }
    
    class func chartBarItem() -> UIBarButtonItem {
        return imagedBarButtonItem(imageName: "ic_chart")
    }
    
}
