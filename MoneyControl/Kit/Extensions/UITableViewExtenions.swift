//
//  UITableViewExtenions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

extension UITableView {
    
    // MARK: - Public methods
    func registerNib<N>(type: N.Type) {
        var className = String(describing: type)
        
        let components = className.components(separatedBy: "<")
        className = components[0]
        
        let sourceNib = UINib(nibName: className, bundle: Bundle.main)
        register(sourceNib, forCellReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableCell<C>(type: C.Type, indexPath: IndexPath) -> C {
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier: className,
                                   for: indexPath) as! C
    }
    
    func registerHeaderFooterNib<N>(type: N.Type) {
        var className = String(describing: type)
        
        let components = className.components(separatedBy: "<")
        className = components[0]
        
        let sourceNib = UINib(nibName: className, bundle: Bundle.main)
        register(sourceNib, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableHeaderFooter<C>(type: C.Type) -> C {
        let className = String(describing: type)
        return dequeueReusableHeaderFooterView(withIdentifier: className) as! C
    }
    
}
