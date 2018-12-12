//
//  EditTransactionCategoryView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class EditTransactionCategoryView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - Variables public
    var category: CategoryViewModel! {
        didSet {
            categoryImageView.image = category.image
            categoryLabel.text = category.title.capitalized
        }
    }
    
    // MARK: - Class methods
    class func view() -> EditTransactionCategoryView {
        let view: EditTransactionCategoryView = EditTransactionCategoryView.nib()
        return view
    }

}
