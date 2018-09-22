//
//  BottomPopupViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/22/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class BottomPopupViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomContentViewConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    private var baseViewOldFrame: CGRect = .zero

    // MARK: - Class methods
    class func controller() -> BottomPopupViewController {
        let controller: BottomPopupViewController = BottomPopupViewController.nib()
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !baseViewOldFrame.equalTo(baseView.frame) {
            baseView.applyCornerRadius(25, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
            baseViewOldFrame = baseView.frame
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        baseView.applyFullyRounded(20)
        
        
        
    }
    
    
    
    // MARK: - Private methods
    private func setupUI() {
        //blur effect
        view.insertSubview(blurEffectView, belowSubview: baseView)
        
        //bottom inset
        if let window = UIApplication.shared.keyWindow {
            bottomContentViewConstraint.constant += window.bottomSafeInset
        }
    }
}
