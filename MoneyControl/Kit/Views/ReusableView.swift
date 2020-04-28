//
//  ReusableView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 18.03.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

public protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
}

extension UICollectionViewCell: ReusableView {
}

extension UITableViewHeaderFooterView: ReusableView {
}
