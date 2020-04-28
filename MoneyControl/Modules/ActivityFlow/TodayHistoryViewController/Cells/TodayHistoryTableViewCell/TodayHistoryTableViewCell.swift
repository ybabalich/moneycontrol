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
        
        setupUI()
        
        rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self._tapClosure?(self._viewModel)
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Public methods
    
    func setupUI() {
        
        // colors
        
        separatorInset = UIEdgeInsets(top: 0, left: 16 + 36 + 16, bottom: 0, right: 0)
        backgroundView?.backgroundColor = .clear
        contentView.backgroundColor = .clear
        categoryNameLabel.textColor = .secondaryText
        categoryNameLabel.textColor = .primaryText
    }
    
    func apply(_ viewModel: TransactionViewModel) {
        _viewModel = viewModel
        
        categoryImageView.image = viewModel.category.image
        valueLabel.text = viewModel.value.currencyFormatted
        categoryNameLabel.text = viewModel.category.title
        valueLabel.textColor = viewModel.type == .incoming ? App.Color.incoming.rawValue : App.Color.outcoming.rawValue
    }
    
    func onTap(completion: @escaping TransactionTapClosure) {
        _tapClosure = completion
    }
    
}
