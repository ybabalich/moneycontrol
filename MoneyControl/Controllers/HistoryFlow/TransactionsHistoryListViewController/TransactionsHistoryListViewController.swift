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
    var historyViewModel: HistoryViewModel? {
        didSet {
            if let historyViewModel = historyViewModel {
                viewModel.historyViewModel = historyViewModel
            }
        }
    }
    
    // MARK: - Varaibles private
    private let viewModel = TransactionsHistoryListViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isFirstLoad {
            reloadData()
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        //general
        customizeBackBtn()
        self.title = "Transactions list".localized
        
        //tableview
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.registerNib(type: TodayHistoryTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel.transactions.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: TodayHistoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            cell.onTap(completion: { (transactionViewModel) in
                Router.instance.showEditTransactionScreen(transactionViewModel)
            })
            
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.loadData()
    }
    
    private func reloadData() {
        viewModel.loadData()
    }

}
