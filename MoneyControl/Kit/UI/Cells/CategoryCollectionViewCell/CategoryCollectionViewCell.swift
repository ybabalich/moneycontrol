//
//  CategoryCollectionViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/24/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variables public
    var isActive: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Variables private
    private var selectedColor: UIColor!
    private var _viewModel: CategoryViewModel!
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setup()
    }
    
    // MARK: - Public methods
    func apply(_ viewModel: CategoryViewModel, transactionType: Transaction.TransactionType) {
        _viewModel = viewModel
        
        titleLabel.text = viewModel.title
        selectedColor = transactionType == .incoming ? App.Color.incoming.rawValue : App.Color.outcoming.rawValue
        imageView.image = viewModel.image
        titleLabel.font = App.Font.main(size: 12, type: .bold).rawValue
    }
    
    func onTap(completion: @escaping (CategoryViewModel) -> ()) {
        rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            completion(self._viewModel)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    private func setup() {
        isActive = false
        titleLabel.textColor = .primaryText
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    private func updateUI() {
        titleLabel.textColor = isActive ? selectedColor : App.Color.main.rawValue
    }
}
