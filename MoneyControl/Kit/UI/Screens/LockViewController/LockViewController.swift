//
//  LockViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/22/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class LockViewController: UIViewController {

    // MARK: - Class methods
    class func controller() -> LockViewController {
        let controller: LockViewController = LockViewController.nib()
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
