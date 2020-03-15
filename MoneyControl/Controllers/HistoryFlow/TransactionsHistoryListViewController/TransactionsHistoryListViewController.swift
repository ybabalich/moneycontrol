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
    private var emptyView: EmptyView = EmptyView.view()
    
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
        
        // colors
        view.backgroundColor = .mainElementBackground
        tableView.backgroundColor = .mainElementBackground
        tableView.separatorColor = .tableSeparator
        
        //general
        customizeBackBtn()
        self.title = "Transactions list".localized
        
        //subviews
        addSubviews()
        
        emptyView.onActionBtnTap {
            Router.instance.goBackToController(type: ActivityViewController.self)
        }
        
        //tableview
        setupViewModel()
    }
    
    private func setupViewModel() {
        //tableView
        configureTableView()
        
        //empty
        viewModel.transactions.asObservable().map({ $0.count > 0 })
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
    
    private func addSubviews() {
        //empty view
        view.addSubview(emptyView)
        emptyView.alignCenterX(toView: view)
        emptyView.alignCenterY(toView: view)
    }

}
