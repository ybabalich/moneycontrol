//
//  TransactionsHistoryListViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/6/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class TransactionsHistoryListViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables public
    let transactions = Variable<[TransactionViewModel]>([])
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        //general
        customizeBackBtn()
        self.title = "Transactions list"
        
        //tableview
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.registerNib(type: TodayHistoryTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        
        transactions.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: TodayHistoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            cell.onTap(completion: { (transactionViewModel) in
                Router.instance.showEditTransactionScreen(transactionViewModel)
            })
            
            return cell
        }.disposed(by: disposeBag)
    }

}
