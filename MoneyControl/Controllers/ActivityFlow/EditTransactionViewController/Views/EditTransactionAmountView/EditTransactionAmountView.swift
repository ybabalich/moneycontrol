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
    @IBOutlet weak var amountTextField: UITextField!
    
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
        return view
    }

}
