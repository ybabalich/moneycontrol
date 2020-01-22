//
//  BiggerAreaButton.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 21.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

@IBDesignable class BiggerAreaButton: TappableButton {
    
    @IBInspectable var clickableInset: CGFloat = 0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let insetFrame = bounds.insetBy(dx: clickableInset, dy: clickableInset)
        return insetFrame.contains(point)
    }
    
}
