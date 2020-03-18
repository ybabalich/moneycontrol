//
//  UITableView+MoneyControl.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

extension UITableView {
    
    // MARK: - Public methods
    
    func register<C: UITableViewCell>(_ cellType: C.Type) {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<C: UITableViewCell>(for inexPath: IndexPath) -> C {
        guard let cell = dequeueReusableCell(withIdentifier: C.reuseIdentifier, for: inexPath) as? C else {
            fatalError("Could not dequeue cwhere C: ReusableViewell: \(C.reuseIdentifier)")
        }
        
        return cell
    }
    
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
