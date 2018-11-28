//
//  CheckButton.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class CheckButton: UIButton {

    enum ColorType {
        case base
        case incoming
        case outcoming
    }
    
    // MARK: - Variables public
    var colorType: ColorType = .outcoming {
        didSet {
            updateUI()
        }
    }
    
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
        setImage(UIImage(named: "ic_check"), for: .normal)
        setTitleColor(.white, for: .normal)
        updateUI()
    }
    
    private func updateUI() {
        var backgroundColor = App.Color.main.rawValue
        switch colorType {
        case .incoming: backgroundColor = App.Color.incoming.rawValue
        case .outcoming: backgroundColor = App.Color.outcoming.rawValue
        default: backgroundColor = App.Color.main.rawValue
        }
        
        backgroundColor = isEnabled ? backgroundColor.withAlphaComponent(1) : backgroundColor.withAlphaComponent(0.3)
        
        self.backgroundColor = backgroundColor
    }

}
