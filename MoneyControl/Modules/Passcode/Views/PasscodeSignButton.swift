//
//  PasscodeSignButton.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

@IBDesignable
class PasscodeSignButton: UIButton {
    
    @IBInspectable var passcodeSign: String = "1"
    
    var borderColor: UIColor = UIColor.primaryText {
        didSet { setupView() }
    }
    
    var highlightBackgroundColor: UIColor = UIColor.primaryText {
        didSet { setupView() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupActions()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
        setupActions()
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 75, height: 75)
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupView()
    }
    
    private var defaultBackgroundColor = UIColor.clear
    private var oldFrame: CGRect = .zero
    
    private func setupView() {
        
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true

        setTitleColor(borderColor, for: .normal)
        
        if let backgroundColor = backgroundColor {
            defaultBackgroundColor = backgroundColor
        }
    }
    
    private func setupActions() {
        
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchDragOutside, .touchCancel])
    }
    
    @objc func handleTouchDown() {
        animateBackgroundColor(color: highlightBackgroundColor)
    }
    
    @objc func handleTouchUp() {
        animateBackgroundColor(color: defaultBackgroundColor)
    }
    
    private func animateBackgroundColor(color: UIColor) {
        
        UIView.animate(
            withDuration: 0.3, delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.backgroundColor = color },
            completion: nil
        )
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if frame != oldFrame {

            layer.cornerRadius = bounds.height / 2
            oldFrame = frame
        }
    }
}
