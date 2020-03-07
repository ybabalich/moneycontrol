//
//  UICollectionViewExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/24/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // MARK: - Public methods
    func registerNib<N>(type: N.Type) {
        let nibName = String(describing: type)
        let sourceNib = UINib(nibName: nibName, bundle: Bundle.main)
        register(sourceNib, forCellWithReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableCell<C>(type: C.Type, indexPath: IndexPath) -> C {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type),
                                   for: indexPath) as! C
    }
    
}
