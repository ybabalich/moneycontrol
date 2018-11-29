//
//  ActivityTopViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/24/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class ActivityTopViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var sumStackView: UIStackView!
    @IBOutlet weak var spendingTypeLabel: UILabel!
    @IBOutlet weak var sumTextField: UITextField!
    
    // MARK: - Variables
    var parentViewModel: ActivityViewViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        sumTextField.isHidden = true
    }
    
    private func setupViewModel() {
        //setup collection view
        configureCollectionView()
        
        parentViewModel.transactionType.subscribe(onNext: { [unowned self] (transactionType) in
            if transactionType == .incoming {
                self.spendingTypeLabel.text = "Incoming"
                self.spendingTypeLabel.textColor = App.Color.incoming.rawValue
            } else {
                self.spendingTypeLabel.text = "Outcoming"
                self.spendingTypeLabel.textColor = App.Color.outcoming.rawValue
            }
        }).disposed(by: disposeBag)
        
        sumStackView.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.parentViewModel.changeTransactionType()
        }).disposed(by: disposeBag)
        
        parentViewModel.isHiddenField.bind(to: sumTextField.rx.isHidden).disposed(by: disposeBag)
        parentViewModel.value.bind(to: sumTextField.rx.text).disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        categoriesCollectionView.registerNib(type: CategoryCollectionViewCell.self)
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        parentViewModel.categories.asObservable().bind(to: categoriesCollectionView.rx.items)
        { [unowned self] (collectionView, row, viewModel) in
            let cell = collectionView.dequeueReusableCell(type: CategoryCollectionViewCell.self,
                                                          indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            cell.onTap { [unowned self] (category) in
                self.makeSelectedCategory(category)
            }
            
            if let selectedCategory = self.parentViewModel.selectedCategory.value, selectedCategory.id == viewModel.id {
                cell.isActive = true
            }
            
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func makeSelectedCategory(_ category: CategoryViewModel) {
        self.parentViewModel.selectedCategory.value = category
        self.categoriesCollectionView.reloadData()
    }

}
