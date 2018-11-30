//
//  TodayHistoryViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class TodayHistoryViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    // MARK: - Variables private
    private var viewModel = TodayHistoryViewViewModel()
    private var navSegmentControl: UISegmentedControl!
    private var emptyView: EmptyView = EmptyView.view()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // navbar preparаtion
    override func createLeftNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.titledBarButtonItem(title: "Activity")
    }
    
    override func createRightNavButton() -> UIBarButtonItem? {
        let navSegmentBarButton = UIBarButtonItemFabric.segmentBar(items: ["Incoming", "Outcoming"])
        self.navSegmentControl = navSegmentBarButton.customView as? UISegmentedControl
        self.navSegmentControl.selectedSegmentIndex = self.viewModel.selectedTransationType.value.rawValue
        return navSegmentBarButton
    }
    
    // MARK: - Private methods
    private func setup() {
        //subviews
        addSubviews()
        
        //events
        subscribeToEvents()
        
        //table view
        configureTableView()
        
        //data
        viewModel.loadData()
    }
    
    private func addSubviews() {
        view.addSubview(emptyView)
        emptyView.alignCenterX(toView: view)
        emptyView.alignCenterY(toView: view)
    }
    
    private func subscribeToEvents() {
        closeBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            Router.instance.goBack()
        }).disposed(by: disposeBag)
        
        navSegmentControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] (value) in
            self.viewModel.selectedTransationType.value = Transaction.TransactionType(rawValue: self.navSegmentControl.selectedSegmentIndex)
        }).disposed(by: disposeBag)
        
        viewModel.transactions.asObserver().map({ $0.count > 0 })
            .subscribe(onNext: { [unowned self] (haveTransactions) in
            
                if haveTransactions {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                } else {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                    self.emptyView.setTitleText("Haven't activities today")
                    self.emptyView.setButtonText("Add new activity")
                }
                
        }).disposed(by: disposeBag)
        
        emptyView.onActionBtnTap {
            Router.instance.goBack()
        }
    }
    
    private func configureTableView() {
        tableView.registerNib(type: TodayHistoryTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel.transactions.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: TodayHistoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            
            return cell
        }.disposed(by: disposeBag)
    }

}
