//
//  ActivityViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift
import RxGesture

class ActivityViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var doneBtn: CheckButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    // MARK: - Variables private
    private var viewModel = ActivityViewViewModel()
    private var topViewController: ActivityTopViewController!
    private var bottomViewController: ActivityBottomViewController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // navbar preparаtion
    override func createLeftNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.titledBarButtonItem(title: "Today")
    }
    
    override func createRightNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.chartBarItem()
    }
    
    override func didBtNavRightClicked() {
        Router.instance.showHistoryScreen()
    }
    
    // MARK: - Private methods
    private func setup() {
        //events
        subscribeToEvents()
        
        //child controllers
        configureChildControllers()
        
        //view model
        setupViewModel()
        
        //data
        viewModel.loadData()
    }
    
    private func setupViewModel() {
        viewModel.transactionType.subscribe(onNext: { [unowned self] (transactionType) in
            if transactionType == .incoming {
                self.doneBtn.colorType = .incoming
                self.totalLabel.textColor = App.Color.incoming.rawValue
            } else {
                self.doneBtn.colorType = .outcoming
                self.totalLabel.textColor = App.Color.outcoming.rawValue
            }
        }).disposed(by: disposeBag)
        
        viewModel.totalValue.subscribe(onNext: { [unowned self] (totalValue) in
            self.totalLabel.text = "Total: \(totalValue)"
        }).disposed(by: disposeBag)
        
        viewModel.isActiveDoneButton.bind(to: doneBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func subscribeToEvents() {
        historyBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            Router.instance.showTodayHistoryScreen()
        }).disposed(by: disposeBag)
        
        doneBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.viewModel.saveTransaction()
        }).disposed(by: disposeBag)
    }
    
    private func configureChildControllers() {
        guard let topController = children.first as? ActivityTopViewController else {
            fatalError("Check storyboard for top view controller")
        }
        
        guard let bottomController = children.last as? ActivityBottomViewController else {
            fatalError("Check storyboard for bottom view controller")
        }
        
        topViewController = topController
        topViewController.parentViewModel = viewModel
        
        bottomViewController = bottomController
        bottomViewController.parentViewModel = viewModel
        
    }
}
