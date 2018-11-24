//
//  ActivityViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class ActivityViewController: BaseViewController {

    // MARK: - Outlets
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // navbar preparаtion
    override func createLeftNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.titledBarButtonItem(title: "Today")
    }
    
    override func createRightNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.chartBarItem()
    }
    

}
