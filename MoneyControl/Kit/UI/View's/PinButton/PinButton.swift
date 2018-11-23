//
//  PinButton.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

@IBDesignable
class PinButton: UIControl {

    // MARK: - Variables
    @IBInspectable public var text: String? {
        didSet {
            self.label.text = text
        }
    }
    private var label = UILabel()
    private var animator = UIViewPropertyAnimator()
    
    // MARK: - Initialization methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        addTargets()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        //rounded corners and border style
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
        layer.borderColor = App.Color.main.rawValue.withAlphaComponent(0.6).cgColor
        layer.borderWidth = 0.7
        
        //label
        addSubview(label)
        label.alignExpandToSuperview()
        label.textColor = App.Color.main.rawValue.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = App.Font.main(size: 16, type: .light).rawValue
    }
    
    private func addTargets() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }

    // MARK: - Events
    @objc private func touchDown() {
        animator.stopAnimation(true)
        backgroundColor = App.Color.main.rawValue.withAlphaComponent(0.2)
        self.label.textColor = .white
    }
    
    @objc private func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.5,
                                          curve: .easeOut,
                                          animations:
        {
            self.backgroundColor = .white
            self.label.textColor = App.Color.main.rawValue.withAlphaComponent(0.8)
        })
        animator.startAnimation()
    }
    
}
