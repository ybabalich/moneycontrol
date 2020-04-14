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
    @IBOutlet weak var balanceStaticLabel: UILabel! {
        didSet {
            balanceStaticLabel.text = "Balance".localized
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var incomesStaticLabel: UILabel! {
        didSet {
            incomesStaticLabel.text = "Revenues".localized.uppercased()
        }
    }
    @IBOutlet weak var incomesLabel: UILabel!
    @IBOutlet weak var outcomesStaticLabel: UILabel! {
        didSet {
            outcomesStaticLabel.text = "Spendings".localized.uppercased()
        }
    }
    @IBOutlet weak var outcomesLabel: UILabel!
    @IBOutlet weak var balanceInfoContentView: UIView!
    
    @IBOutlet weak var currencyBalanceLabel: UILabel!
    @IBOutlet weak var currencyIncomeLabel: UILabel!
    @IBOutlet weak var currencyExpenseLabel: UILabel!
    
    // MARK: - Variables public
    var parentViewModel: HistoryViewViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Variables private
    private var oldFrame: CGRect = .zero
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if oldFrame != view.frame {
            balanceInfoContentView.applyFullyRounded(15)
            oldFrame = view.frame
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        
        //colors
        view.backgroundColor = .mainBackground
        balanceInfoContentView.backgroundColor = .mainElementBackground
        currencyBalanceLabel.textColor = .primaryText
        currencyIncomeLabel.textColor = .primaryText
        currencyExpenseLabel.textColor = .primaryText
        balanceStaticLabel.textColor = .primaryText
        balanceLabel.textColor = .primaryText
        incomesStaticLabel.textColor = .primaryText
        outcomesStaticLabel.textColor = .primaryText
        
        //currencies label's
        currencyBalanceLabel.text = settings.currency!.symbol.uppercased()
        currencyIncomeLabel.text = settings.currency!.symbol.uppercased()
        currencyExpenseLabel.text = settings.currency!.symbol.uppercased()
    }
    
    private func setupViewModel() {
        parentViewModel.statisticsValues.asObserver().subscribe(onNext: { [unowned self] (values) in
            let (balance, incomesValue, outcomesValue) = values
            
            self.balanceLabel.text = balance.currencyFormatted
            self.incomesLabel.text = incomesValue.currencyFormatted
            self.outcomesLabel.text = outcomesValue.currencyFormatted
        }).disposed(by: disposeBag)
    }
    
    private func makeSelectedCategory(_ category: HistorySortCategoryViewModel) {
        self.parentViewModel.selectedSortCategory.value = category
    }

}
