//
//  UIViewControllerExtensions.swift
//  FadFed
//
//  Created by Yaroslav Babalich on 2/5/18.
//  Copyright © 2018 Wefaaq Co. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Class methods
    class func nib<T: UIViewController>() -> T {
        var className = NSStringFromClass(self)
        className = className.split{$0 == "."}.map(String.init)[1]
        return T(nibName: className, bundle: Bundle.main)
    }
    
}
