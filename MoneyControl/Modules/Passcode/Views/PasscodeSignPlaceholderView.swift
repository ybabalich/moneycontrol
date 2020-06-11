//
//  PasscodeSignPlaceholderView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

@IBDesignable
public class PasscodeSignPlaceholderView: UIView {
    
    public enum State {
        case inactive
        case active
        case error
    }
    
    @IBInspectable
    public var inactiveColor: UIColor = UIColor.white {
        didSet { setupView() }
    }
    
    @IBInspectable
    public var activeColor: UIColor = UIColor.gray {
        didSet { setupView() }
    }
    
    @IBInspectable
    public var errorColor: UIColor = UIColor.systemRed {
        didSet { setupView() }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 16, height: 16)
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupView()
    }
    
    private func setupView() {
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        state = nil ?? state
    }
    
    private func colorsForState(state: State) -> (backgroundColor: UIColor, borderColor: UIColor) {
        
        switch state {
        case .inactive: return (inactiveColor, activeColor)
        case .active: return (activeColor, activeColor)
        case .error: return (activeColor, activeColor)
        }
    }

    public var state: State = .inactive {
        didSet {
            let colors = colorsForState(state: state)
            backgroundColor = colors.backgroundColor
            layer.borderColor = colors.borderColor.cgColor
        }
    }

    func setState(_ state: State, animated: Bool) {

        UIView.animate(
            withDuration: animated ? 0.5 : 0, delay: 0,
            usingSpringWithDamping: 1, initialSpringVelocity: 0,
            options: [.beginFromCurrentState],
            animations: { self.state = state },
            completion: nil
        )
    }
}

