//
//  YourBalanceViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/18/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import RxSwift

class YourBalanceViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var yourBalanceLabel: UILabel! {
        didSet {
            yourBalanceLabel.text = "Your Balance".localized
        }
    }
    @IBOutlet weak var saveBtn: CheckButton! {
        didSet {
            saveBtn.colorType = .incoming
        }
    }
    @IBOutlet weak var balanceTextfield: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    
    // MARK: - Private variables
    private let viewModel = YourBalanceViewViewModel()
    private var keyboardNotifier = KeyboardNotificator()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        balanceTextfield.becomeFirstResponder()
    }
    
    // MARK: - Private methods
    private func setup() {
        //ui
        currencyLabel.text = viewModel.currencySymbol()
        
        //load data
        viewModel.loadData(balanceObs: balanceTextfield.rx.text.orEmpty.asObservable())
        
        //view model
        viewModel.isActiveSaveBtn.asObservable().bind(to: saveBtn.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isSuccess.subscribe(onNext: { (isSuccess) in
            if isSuccess {
                Router.instance.showActivityScreen()
            }
        }).disposed(by: disposeBag)
        
        //events
        saveBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.viewModel.save()
        }).disposed(by: disposeBag)
        
        //keyboard notificator
        keyboardNotifier.onEvent { [unowned self] (event, keyboardFrame) in
            if event == .willShow {
                let padding = -(keyboardFrame.height + 16)
                
                if let contraint = self.saveBtn.constraintBetween(second: self.view, attr: .bottom) {
                    contraint.constant = padding
                    return
                }
                
                self.saveBtn.alignBottom(toView: self.view, toBottom: true, padding: padding)
            } else if event == .willHide {
                let padding: CGFloat = -24
                
                if let contraint = self.saveBtn.constraintBetween(second: self.view, attr: .bottom) {
                    contraint.constant = padding
                    return
                }
                
                self.saveBtn.alignBottom(toView: self.view, toBottom: true, padding: padding)
            }
        }
        
        view.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.balanceTextfield.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    
}
