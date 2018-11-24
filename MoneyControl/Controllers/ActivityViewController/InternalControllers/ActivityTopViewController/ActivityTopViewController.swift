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
    @IBOutlet weak var spendingTypeLabel: UIStackView!
    @IBOutlet weak var sumTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        categoriesCollectionView.registerNib(type: CategoryCollectionViewCell.self)
//        categoriesCollectionView.delegate = self
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        let categories: Variable<[String]> = Variable<[String]>([])
        
        categories.asObservable().bind(to: categoriesCollectionView.rx.items)
        { [unowned self] (collectionView, row, viewModel) in
            let cell = collectionView.dequeueReusableCell(type: CategoryCollectionViewCell.self,
                                                          indexPath: IndexPath(row: row, section: 0))
            /*if self.viewModel.currentSelectedCategory.value.id == viewModel.id {
                viewModel.isSelected = true
            }
            
            cell.apply(viewModel)
            
            cell.onTap { [unowned self] (category) in
                self.makeSelectedCategory(category)
            }(*/
            
            return cell
        }.disposed(by: disposeBag)
        
        categories.value = ["adasd", "asdasd", "asdasd",
                            "asdasd", "asdasd", "asdasd",
                            "asdasd", "asdasd", "asdasd"]
    }

}
