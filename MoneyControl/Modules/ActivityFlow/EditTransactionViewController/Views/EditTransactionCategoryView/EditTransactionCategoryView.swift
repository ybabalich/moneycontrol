//
//  EditTransactionCategoryView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class EditTransactionCategoryView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Private variables
    private let disposeBag = DisposeBag()
    
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
        view.titleLabel.text = "Category".localized
        view.setupUI()
        return view
    }
    
    // MARK: - Public methods
    func onTap(completion: @escaping EmptyClosure) {
        rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            completion()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        // colors
        
        titleLabel.textColor = .secondaryText
        categoryLabel.textColor = .secondaryText
        separatorView.backgroundColor = .tableSeparator
    }

}
