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
        tableContentView.layer.masksToBounds = true
    }
    
    // MARK: - Private methods
    private func setupViewModel() {
        //table view
        configureTableView()
    }
    
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
