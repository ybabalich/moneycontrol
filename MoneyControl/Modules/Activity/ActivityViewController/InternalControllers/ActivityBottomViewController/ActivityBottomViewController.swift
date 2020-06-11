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
    @IBOutlet var butons: [UIButton]!
    @IBOutlet weak var baseContentView: UIView!
    
    // MARK: - Variables public
    var parentViewModel: ActivityViewViewModel! {
        didSet {
            setup()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocalization()
    }
    
    override func updateLocalization() {
        super.updateLocalization()
        
        butons.forEach { (button) in
            if button.tag == 11 { //clear button
                button.setTitle("Clear".localized, for: .normal)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        baseContentView.applyCornerRadius(15, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
    }
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .mainBackground
        baseContentView.backgroundColor = .mainElementBackground
        
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
            
            button.setTitleColor(.primaryText, for: .normal)
        }
    }

}
