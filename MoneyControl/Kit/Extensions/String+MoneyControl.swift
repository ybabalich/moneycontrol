//
//  String+MoneyControl.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 15.03.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

extension String {
    
    // MARK: - Texts
    
    func size(constrainedToWidth: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let constraintRect = CGSize(width: constrainedToWidth, height: .greatestFiniteMagnitude)
        return self.boundingRect(with: constraintRect,
                                 options: [.usesLineFragmentOrigin], attributes: attributes, context: nil).size
    }
    
    func size(constrainedToHeight: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: constrainedToHeight)
        return self.boundingRect(with: constraintRect,
                                 options: [.usesLineFragmentOrigin], attributes: attributes, context: nil).size
    }
    
}
