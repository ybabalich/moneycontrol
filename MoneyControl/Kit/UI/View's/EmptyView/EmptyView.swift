//
//  EmptyView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/30/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class EmptyView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    // MARK: - Variables private
    private let disposeBag = DisposeBag()
    
    // MARK: - Class methods
    class func view() -> EmptyView {
        let view: EmptyView = EmptyView.nib()
        view.widthConstraint(needCreate: true)?.constant = 287
        view.heightConstraint(needCreate: true)?.constant = 130
        view.setup()
        return view
    }
    
    // MARK: - Public methods
    func setTitleText(_ titleText: String) {
        textLabel.text = titleText
    }
    
    func setButtonText(_ buttonText: String?) {
        if buttonText != nil {
            actionBtn.isHidden = false
            actionBtn.setTitle(buttonText, for: .normal)
        } else {
            actionBtn.isHidden = true
        }
    }
    
    func onActionBtnTap(completion: @escaping EmptyClosure) {
        actionBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            completion()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    private func setup() {
        
        // colors
        
        backgroundColor = .clear
        textLabel.textColor = .primaryText
        actionBtn.backgroundColor = .controlTintActive
        actionBtn.setTitleColor(.primaryText, for: .normal)
        
        // general
        
        actionBtn.layer.cornerRadius = 5
    }

}
