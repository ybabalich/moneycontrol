//
//  UIViewControllerExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 2/5/18.
//  Copyright © 2018 RxToday Co. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Class methods
    class func by(flow: AppLaunch.StoryboardFlow) -> UIViewController {
        let flowData = flow.rawValue
        if flowData.isInitial {
            return UIStoryboard(name: flowData.storyboardName,
                                bundle: nil).instantiateInitialViewController()!
        } else {
            return UIStoryboard(name: flowData.storyboardName,
                                bundle: nil).instantiateViewController(withIdentifier: flowData.controllerName!)
        }
    }
    
    class func nib<T: UIViewController>() -> T {
        var className = NSStringFromClass(self)
        className = className.split{$0 == "."}.map(String.init)[1]
        return T(nibName: className, bundle: Bundle.main)
    }
    
    class func topController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    // MARK: - Public methods
    func add(_ child: UIViewController, to view: UIView) {
        view.removeAllSubviews()
        addChild(child)
        view.addSubview(child.view)
        child.view.alignExpandToSuperview()
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
}

