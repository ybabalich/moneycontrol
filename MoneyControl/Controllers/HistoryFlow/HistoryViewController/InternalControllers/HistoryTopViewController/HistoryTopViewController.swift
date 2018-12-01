//
//  HistoryTopViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class HistoryTopViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var incomesLabel: UILabel!
    @IBOutlet weak var outcomesLabel: UILabel!
    @IBOutlet weak var balanceInfoContentView: UIView!
    
    // MARK: - Variables public
    var parentViewModel: HistoryViewViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        balanceInfoContentView.applyFullyRounded(15)
    }
    
    private func setupViewModel() {
        //collection view
        configureCollectionView()
        
        parentViewModel.statisticsValues.asObserver().subscribe(onNext: { [unowned self] (values) in
            let (incomesValue, outcomesValue) = values
            
            self.incomesLabel.text = "\(incomesValue)"
            self.outcomesLabel.text = "\(outcomesValue)"
        }).disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        collectionView.registerNib(type: HistoryTopCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false

        parentViewModel.sortCategories.asObservable().bind(to: collectionView.rx.items)
        { [unowned self] (collectionView, row, viewModel) in
            let cell = collectionView.dequeueReusableCell(type: HistoryTopCollectionViewCell.self,
                                                          indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            cell.onTap(completion: { [unowned self] (category) in
                self.makeSelectedCategory(category)
            })
            
            if self.parentViewModel.selectedSortCategory.value.sortType == viewModel.sortType {
                cell.isActive = true
            }
        
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func makeSelectedCategory(_ category: HistorySortCategoryViewModel) {
        self.parentViewModel.selectedSortCategory.value = category
        self.collectionView.reloadData()
    }

}

extension HistoryTopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenSize = UIScreen.main.bounds
        let result = CGSize(width: screenSize.width / 3, height: 33)
        
        return result
    }
}
