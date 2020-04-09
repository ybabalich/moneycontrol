//
//  UIBarButtonItemFabric.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/24/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit
import SnapKit

class UIBarButtonItemFabric {
    
    // MARK: - Private Class Methods
    private class func imagedBarButtonItem(image: UIImage?,
                                           size: CGSize,
                                           onTap: @escaping EmptyClosure) -> UIBarButtonItem {

        let button = BiggerAreaButton(type: .system)
        button.clickableInset = -5
        button.setImage(image, for: .normal)
        button.tintColor = .controlTintActive
        
        button.onTap(completion: onTap)

        if #available(iOS 11, *) {
            button.snp.makeConstraints {
                $0.width.equalTo(size.width)
                $0.height.equalTo(size.height)
            }
        } else {
            button.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            button.imageView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        
        button.contentHorizontalAlignment = .center
        
        return UIBarButtonItem(customView: button)
    }
    
    class func segmentBar(items: [Any]?) -> UIBarButtonItem {
        let segment = UISegmentedControl(items: items)
        
        if #available(iOS 13, *) {
            segment.selectedSegmentTintColor = App.Color.main.rawValue
            
            let unselectedAttributes = [NSAttributedString.Key.foregroundColor: App.Color.main.rawValue];
            let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];
            
            segment.setTitleTextAttributes(unselectedAttributes, for: .normal)
            segment.setTitleTextAttributes(selectedAttributes, for: .selected)
        } else {
            segment.tintColor = App.Color.main.rawValue
        }
        
        return UIBarButtonItem(customView: segment)
    }
    
    // MARK: - Public Class Methods
    class func titledBarButtonItem(title: String, fontSize: CGFloat = 28) -> UIBarButtonItem {
        let label: UILabel = UILabel()
        
        label.font = App.Font.main(size: fontSize, type: .bold).rawValue
        label.textColor = .primaryText
        label.text = title
        label.sizeToFit()
        
        return UIBarButtonItem(customView: label)
    }
    
    class func chartBarItem(onTap: @escaping EmptyClosure) -> UIBarButtonItem {
        
        var image: UIImage? = UIImage(named: "ic_chart")
        var size = CGSize(width: 23, height: 20)
        
        if #available(iOS 13, *) {
            image = UIImage(systemName: "chart.pie.fill")
            size = CGSize(width: 27, height: 27)
        }
        
        return imagedBarButtonItem(image: image, size: size, onTap: onTap)
    }
    
    class func settingsBarItem(onTap: @escaping EmptyClosure) -> UIBarButtonItem {
        
        var image: UIImage? = UIImage(named: "ic_settings")
        var size = CGSize(width: 23, height: 20)
        
        if #available(iOS 13, *) {
            image = UIImage(systemName: "gear")
            size = CGSize(width: 27, height: 27)
        }
        
        return imagedBarButtonItem(image: image,
                                   size: size,
                                   onTap: onTap)
    }
    
}
