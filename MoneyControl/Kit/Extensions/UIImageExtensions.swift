//
//  UIImageExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 21.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

extension UIImage {
    
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
