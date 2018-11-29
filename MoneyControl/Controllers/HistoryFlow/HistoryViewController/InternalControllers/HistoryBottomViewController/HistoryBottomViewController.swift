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
    
    // MARK: - Variables public
    var parentViewModel: HistoryViewViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public methods
    func setupViewModel() {
        //table view
        configureTableView()
    }
    
    // MARK: - Private methods
    private func configureTableView() {
        tableView.registerNib(type: TodayHistoryTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        
        parentViewModel.transactions.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: TodayHistoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            
            return cell
        }.disposed(by: disposeBag)
    }
    

}
