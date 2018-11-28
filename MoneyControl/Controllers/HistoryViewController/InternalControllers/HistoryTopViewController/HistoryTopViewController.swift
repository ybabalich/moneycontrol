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
        collectionView.registerNib(type: HistoryTopCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        let categories: Variable<[String]> = Variable<[String]>([])
        
        categories.asObservable().bind(to: collectionView.rx.items)
        { [unowned self] (collectionView, row, viewModel) in
            let cell = collectionView.dequeueReusableCell(type: HistoryTopCollectionViewCell.self,
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
        
        categories.value = ["adasd", "asdasd", "asdasd"]
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
