//
//  TodayHistoryTableViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class TodayHistoryTableViewCell : UITableViewCell {

    typealias TransactionTapClosure = (TransactionViewModel) -> ()
    
    // MARK: - Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    // MARK: - Variables private
    private var _tapClosure: TransactionTapClosure?
    private var _viewModel: TransactionViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self._tapClosure?(self._viewModel)
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Public methods
    func apply(_ viewModel: TransactionViewModel) {
        _viewModel = viewModel
        
        categoryImageView.image = viewModel.category.image
        valueLabel.text = String(format: "%3.2f", viewModel.value)
        valueLabel.textColor = viewModel.type == .incoming ? App.Color.incoming.rawValue : App.Color.outcoming.rawValue
        categoryNameLabel.text = viewModel.category.title
    }
    
    func onTap(completion: @escaping TransactionTapClosure) {
        _tapClosure = completion
    }
    
}
