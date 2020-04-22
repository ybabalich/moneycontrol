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
            size = CGSize(width: 30, height: 30)
        }
        
        return imagedBarButtonItem(image: image, size: size, onTap: onTap)
    }
    
    class func settingsBarItem(onTap: @escaping EmptyClosure) -> UIBarButtonItem {
        
        var image: UIImage? = UIImage(named: "ic_settings")
        var size = CGSize(width: 23, height: 23)
        
        if #available(iOS 13, *) {
            image = UIImage(systemName: "gear")
            size = CGSize(width: 27, height: 27)
        }
        
        return imagedBarButtonItem(image: image,
                                   size: size,
                                   onTap: onTap)
    }
    
    class func calendar(onTap: @escaping EmptyClosure) -> UIBarButtonItem {
        
        var image: UIImage? = UIImage(named: "ic_calendar")
        var size = CGSize(width: 23, height: 23)
        
        if #available(iOS 13, *) {
            image = UIImage(systemName: "calendar")
            size = CGSize(width: 27, height: 27)
        }
        
        return imagedBarButtonItem(image: image, size: size, onTap: onTap)
    }
    
    class func entity(sortEntity: SortEntity, onTap: @escaping EmptyClosure) -> UIBarButtonItem {
        
        let walletButton = TappableButton(type: .system).then { v in
            
            v.setBackgroundImage(sortEntity.stringValue.initials().coverImage, for: .normal)
            v.tintColor = .controlTintActive
            v.applyFullyRounded(15)

            v.onTap(completion: onTap)
            
            v.snp.makeConstraints {
                $0.width.height.equalTo(30)
            }
        }
        
        let downImage = TappableButton(type: .system).then { v in

            let image = UIImage(named: "ic_down_arrow")

            v.setBackgroundImage(image, for: .normal)
            v.tintColor = .controlTintActive
            
            v.snp.makeConstraints {
                $0.width.equalTo(10)
                $0.height.equalTo(9)
            }
        }
        
        let stackView = UIStackView().then { stackView in
            stackView.distribution = .equalSpacing
            stackView.spacing = 6
            stackView.axis = .horizontal
            stackView.alignment = .center
            
            stackView.addArrangedSubview(walletButton)
            stackView.addArrangedSubview(downImage)
        }
        
        return UIBarButtonItem(customView: stackView)
    }
    
    static func close(onTap: @escaping EmptyClosure) -> UIBarButtonItem {

        let button = TappableButton(type: .system).then { v in

            v.setTitle("Close".localized, for: .normal)
            v.tintColor = .controlTintActive
            v.titleLabel?.font = .systemFont(ofSize: 17)

            v.onTap(completion: onTap)
        }

        return UIBarButtonItem(customView: button)
    }
    
    static func add(onTap: @escaping EmptyClosure) -> UIBarButtonItem {

        let button = TappableButton(type: .system).then { button in

            button.setTitle("Add".localized, for: .normal)
            button.tintColor = .controlTintActive
            button.titleLabel?.font = .systemFont(ofSize: 17)

            button.onTap(completion: onTap)
        }

        return UIBarButtonItem(customView: button)
    }
    
    static func edit(onTap: @escaping EmptyClosure) -> UIBarButtonItem {

        let button = TappableButton(type: .system).then { button in

            button.setTitle("Edit".localized, for: .normal)
            button.tintColor = .controlTintActive
            button.titleLabel?.font = .systemFont(ofSize: 17)

            button.onTap(completion: onTap)
        }

        return UIBarButtonItem(customView: button)
    }
    
    static func save(onTap: @escaping EmptyClosure) -> UIBarButtonItem {

        let button = TappableButton(type: .system).then { button in

            button.setTitle("Save".localized, for: .normal)
            button.tintColor = .controlTintActive
            button.titleLabel?.font = .systemFont(ofSize: 17)

            button.onTap(completion: onTap)
        }

        return UIBarButtonItem(customView: button)
    }
}
