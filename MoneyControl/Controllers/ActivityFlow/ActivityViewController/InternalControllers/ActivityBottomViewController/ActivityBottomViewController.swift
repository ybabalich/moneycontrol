//
//  ActivityBottomViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/24/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class ActivityBottomViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet var butons: [UIButton]! {
        didSet {
            butons.forEach { (button) in
                if button.tag == 11 { //clear button
                    button.setTitle("Clear".localized, for: .normal)
                }
            }
        }
    }
    @IBOutlet weak var baseContentView: UIView!
    
    // MARK: - Variables public
    var parentViewModel: ActivityViewViewModel! {
        didSet {
            setup()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        baseContentView.applyFullyRounded(15)
    }
    
    // MARK: - Private methods
    private func setup() {
        butons.forEach { (button) in
            button.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
                var buttonType: ActivityViewViewModel.KeyboardButtonType = .one
                switch button.tag {
                case 1: buttonType = .one
                case 2: buttonType = .two
                case 3: buttonType = .three
                case 4: buttonType = .four
                case 5: buttonType = .five
                case 6: buttonType = .six
                case 7: buttonType = .seven
                case 8: buttonType = .eight
                case 9: buttonType = .nine
                case 0: buttonType = .zero
                case 10: buttonType = .dot
                case 11: buttonType = .clear
                default: buttonType = .one
                }
                
                self.parentViewModel.keyboardValue(buttonType)
            }).disposed(by: disposeBag)
        }
    }

}
