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
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var outcomeBtn: RegularButton!
    @IBOutlet weak var incomeBtn: RegularButton!
    
    // MARK: - Variables
    var parentViewModel: ActivityViewViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Variables private
    private var oldSize: CGRect = .zero
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if oldSize != view.frame {
            baseContentView.applyFullyRounded(15)
            
            oldSize = view.frame
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        sumTextField.isHidden = true
    }
    
    private func setupViewModel() {
        //setup collection view
        configureCollectionView()
        
        parentViewModel.transactionType.asObservable().subscribe(onNext: { [unowned self] (transactionType) in
            if transactionType == .incoming {
                self.incomeBtn.isEnabled = false
                self.outcomeBtn.isEnabled = true
                
                self.sumTextField.textColor = App.Color.incoming.rawValue
            } else {
                self.incomeBtn.isEnabled = true
                self.outcomeBtn.isEnabled = false
                
                self.sumTextField.textColor = App.Color.outcoming.rawValue
            }
        }).disposed(by: disposeBag)
        
        outcomeBtn.rx.tapGesture().when(.recognized).asObservable().subscribe(onNext: { [unowned self] _ in
            self.parentViewModel.changeTransactionType()
        }).disposed(by: disposeBag)

        incomeBtn.rx.tapGesture().when(.recognized).asObservable().subscribe(onNext: { [unowned self] _ in
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
            
            cell.apply(viewModel, transactionType: self.parentViewModel.transactionType.value)
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
