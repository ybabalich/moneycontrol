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
    func apply(_ viewModel: CategoryViewModel) {
        _viewModel = viewModel
        
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
    }
    
    func onTap(completion: @escaping (CategoryViewModel) -> ()) {
        rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            completion(self._viewModel)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    private func setup() {
        isActive = false
    }
    
    private func updateUI() {
        titleLabel.textColor = isActive ? App.Color.incoming.rawValue : App.Color.main.rawValue
    }
    
    
}