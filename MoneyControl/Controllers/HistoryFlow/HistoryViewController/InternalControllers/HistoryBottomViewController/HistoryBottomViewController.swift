//
//  HistoryBottomViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class HistoryBottomViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableContentView: UIView!
    
    // MARK: - Variables public
    var parentViewModel: HistoryViewViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Variables private
    private var emptyView: EmptyView = EmptyView.view()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableContentView.applyCornerRadius(15, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
    }
    
    // MARK: - Public methods
    func setupUI() {
        //general
        tableContentView.layer.masksToBounds = true
        
        //subviews
        addSubviews()
        
        //events
        emptyView.onActionBtnTap {
            Router.instance.goBack()
        }
    }
    
    // MARK: - Private methods
    private func setupViewModel() {
        //table view
        configureTableView()
        
        parentViewModel.transactions.asObservable().map({ $0.count > 0 })
            .subscribe(onNext: { [unowned self] (haveTransactions) in
                
                if haveTransactions {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                } else {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                    self.emptyView.setTitleText("Haven't transactions".localized)
                    self.emptyView.setButtonText("Add new transaction".localized)
                }
                
        }).disposed(by: disposeBag)
    }
    
    private func addSubviews() {
        view.addSubview(emptyView)
        emptyView.alignCenterX(toView: view)
        emptyView.alignCenterY(toView: view)
    }
    
    private func configureTableView() {
        tableView.registerNib(type: TodayHistoryTableViewCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.tableFooterView = UIView(frame: .zero)
        
        parentViewModel.transactions.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: TodayHistoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            cell.onTap(completion: { (transaction) in
                Router.instance.showTransactionsList(transaction.innerTransactions)
            })
            
            return cell
        }.disposed(by: disposeBag)
    }
    

}

extension HistoryBottomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "Remove".localized) { [unowned self] (action, indexPath) in
            let transactionViewModel = self.parentViewModel.transactions.value[indexPath.row]
            self.parentViewModel.removeInnerTransactions(transactionViewModel)
        }
        return [removeAction]
    }
}
