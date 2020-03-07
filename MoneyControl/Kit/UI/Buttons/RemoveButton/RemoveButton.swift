//
//  RemoveButton.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class RemoveButton: UIButton {
    
    // MARK: - Variables public
    override var isEnabled: Bool {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Variables private
    private var oldFrame: CGRect = .zero
    
    // MARK: - Initialize methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if oldFrame != frame {
            layer.cornerRadius = frame.height / 2
            
            oldFrame = frame
        }
    }
    
    
    // MARK: - Private methods
    private func setup() {
        setTitle(nil, for: .normal)
        setImage(UIImage(named: "ic_remove"), for: .normal)
        setTitleColor(.white, for: .normal)
        updateUI()
    }
    
    private func updateUI() {
        var backgroundColor = App.Color.outcoming.rawValue
        backgroundColor = isEnabled ? backgroundColor.withAlphaComponent(1) : backgroundColor.withAlphaComponent(0.3)
        self.backgroundColor = backgroundColor
    }
    
}
