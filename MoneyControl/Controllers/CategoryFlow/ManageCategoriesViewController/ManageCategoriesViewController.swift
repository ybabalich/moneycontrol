//
//  ManageCategoriesViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/3/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift
import RxDataSources

class ManageCategoriesViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableViewContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: CheckButton! {
        didSet {
            saveBtn.colorType = .incoming
        }
    }
    
    // MARK: - Variables private
    private let viewModel = ManageCategoriesViewViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewContentView.applyFullyRounded(15)
    }
    
    // MARK: - Private methods
    private func setup() {
        //general
        customizeBackBtn()
        title = "Manage categories"
        
        //events
        subscribeToEvents()
        
        //table view
        configureTableView()
        
        //load data
        viewModel.loadData()
    }
    
    private func subscribeToEvents() {
        segmentControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] (value) in
            let type: Transaction.TransactionType = self.segmentControl.selectedSegmentIndex == 0 ? .outcoming : .incoming
            self.viewModel.selectedTransationType.value = type
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.registerNib(type: ManagedCategoryTableViewCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel.categories.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: ManagedCategoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            /*cell.onTap(completion: { (transactionViewModel) in
                Router.instance.showEditTransactionScreen(transactionViewModel)
            })*/
            
            return cell
        }.disposed(by: disposeBag)
    }
    
}

extension ManageCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove".localized) { [unowned self] (action, indexPath) in
            let category = self.viewModel.categories.value[indexPath.row]
            self.viewModel.removeCategory(category)
        }
        return [deleteAction]
    }
}
