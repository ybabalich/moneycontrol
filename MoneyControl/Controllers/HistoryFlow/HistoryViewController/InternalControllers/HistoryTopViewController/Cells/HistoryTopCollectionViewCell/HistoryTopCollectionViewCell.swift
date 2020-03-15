//
//  HistoryTopCollectionViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class HistoryTopCollectionViewCell: UICollectionViewCell {

    // MARK: - Outletes
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - Variables public
    var isActive: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Variables private
    private var _viewModel: HistorySortCategoryViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearUI()
    }
    
    // MARK: - Public methods
    func apply(_ viewModel: HistorySortCategoryViewModel) {
        _viewModel = viewModel
        
        titleLabel.text = viewModel.title
    }
    
    func onTap(completion: @escaping (HistorySortCategoryViewModel) -> ()) {
        rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            completion(self._viewModel)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    private func setup() {
        
        // colors
        titleLabel.textColor = .primaryText
        bottomView.backgroundColor = .controlTintActive
        
        // general
        
        isActive = false
        bottomView.layer.cornerRadius = bottomView.frame.height / 2
    }
    
    private func clearUI() {
        bottomView.alpha = 0
        titleLabel.text = nil
    }
    
    private func updateUI() {
        bottomView.alpha = isActive ? 1 : 0
    }

}
