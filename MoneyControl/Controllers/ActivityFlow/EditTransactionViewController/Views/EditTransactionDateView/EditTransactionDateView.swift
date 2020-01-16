//
//  EditTransactionDateView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/3/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class EditTransactionDateView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Variables public
    var text: String {
        get {
            return dateLabel.text ?? ""
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    // MARK: - Variables private
    private let disposeBag = DisposeBag()
    
    // MARK: - Class methods
    class func view() -> EditTransactionDateView {
        let view: EditTransactionDateView = EditTransactionDateView.nib()
        view.titleLabel.text = "Date".localized
        return view
    }
    
    // MARK: - Public methods
    func onTap(completion: @escaping EmptyClosure) {
        rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            completion()
        }).disposed(by: disposeBag)
    }

}
