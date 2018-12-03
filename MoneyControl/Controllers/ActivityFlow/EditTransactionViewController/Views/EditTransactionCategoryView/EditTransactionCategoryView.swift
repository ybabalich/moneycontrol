//
//  EditTransactionCategoryView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class EditTransactionCategoryView: UIView {

    // MARK: - Class methods
    class func view() -> EditTransactionCategoryView {
        let view: EditTransactionCategoryView = EditTransactionCategoryView.nib()
        return view
    }

}
