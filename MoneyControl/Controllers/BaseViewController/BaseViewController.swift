//
//  BaseViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var topChartView: UIView!
    
    // MARK: - Class methods
    class func controller() -> BaseViewController {
        let controller: BaseViewController = BaseViewController.nib()
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        topChartView.layer.cornerRadius = topChartView.bounds.width / 2
        topChartView.layer.masksToBounds = true
    }
    

    // MARK: - Events
    
}
