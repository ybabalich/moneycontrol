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
    private class func imagedBarButtonItem(imageName: String,
                                           size: CGSize,
                                           color: UIColor?,
                                           onTap: @escaping EmptyClosure) -> UIBarButtonItem
    {
        let imageColor = (color != nil) ? color! : App.Color.main.rawValue
        
        let backgroundImage: UIImage? = UIImage(named: imageName)?.tinted(with: imageColor)
        
        let button = BiggerAreaButton(type: .system)
        button.clickableInset = -20
        button.setImage(backgroundImage, for: .normal)
        button.tintColor = imageColor
        
        button.onTap(completion: onTap)
        
        if #available(iOS 11, *) {
            button.imageView?.snp.makeConstraints {
                $0.width.equalTo(size.width)
                $0.height.equalTo(size.height)
            }
            
            button.snp.makeConstraints {
                $0.width.equalTo(size.width * 1.5)
                $0.height.equalTo(size.height * 1.5)
            }
        } else {
            button.frame = CGRect(x: 0, y: 0, width: size.width * 1.5, height: size.height * 1.5)
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
        label.textColor = App.Color.main.rawValue
        label.text = title
        label.sizeToFit()
        
        return UIBarButtonItem(customView: label)
    }
    
    class func chartBarItem(onTap: @escaping EmptyClosure) -> UIBarButtonItem {
        return imagedBarButtonItem(imageName: "ic_chart",
                                   size: CGSize(width: 23, height: 20),
                                   color: nil,
                                   onTap: onTap)
    }
    
    class func settingsBarItem(onTap: @escaping EmptyClosure) -> UIBarButtonItem {
        return imagedBarButtonItem(imageName: "ic_settings",
                                   size: CGSize(width: 23, height: 23),
                                   color: nil,
                                   onTap: onTap)
    }
    
}
