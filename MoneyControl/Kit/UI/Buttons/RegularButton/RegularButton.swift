//
//  RegularButton.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class RegularButton: UIButton {

    // MARK: - Variables
    override var isEnabled: Bool {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private methods
    private func updateUI() {
        alpha = isEnabled ? 1.0 : 0.4
    }

}
