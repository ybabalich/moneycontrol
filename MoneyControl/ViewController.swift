//
//  ViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/17/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Events
    @IBAction func shopPopupEvent(_ sender: UIButton) {
        let controller = LockViewController.controller()
        controller.modalPresentationStyle = .custom
        navigationController?.present(controller,
                                      animated: true,
                                      completion: nil)
    }
    

}

