//
//  EditTransactionAmountView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class EditTransactionAmountView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Variables public
    var text: String {
        get {
            return amountTextField.text ?? ""
        }
        set {
            amountTextField.text = newValue
        }
    }
    
    // MARK: - Class methods
    
    class func view() -> EditTransactionAmountView {
        let view: EditTransactionAmountView = EditTransactionAmountView.nib()
        view.titleLabel.text = "Amount".localized
        view.setupUI()
        return view
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        // colors
        
        titleLabel.textColor = .secondaryText
        amountTextField.textColor = .secondaryText
        separatorView.backgroundColor = .tableSeparator
    }

}
