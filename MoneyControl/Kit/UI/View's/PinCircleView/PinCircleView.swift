//
//  PinCircleView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class PinCircleView: UIView {

    // MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        backgroundColor = .clear
        
        //rounded corners and border style
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
        layer.borderColor = App.Color.main.rawValue.cgColor
        layer.borderWidth = 0.5
    }

}
