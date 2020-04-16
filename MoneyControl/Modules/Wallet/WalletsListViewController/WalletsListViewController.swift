//
//  WalletsListViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 13.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

protocol WalletsListViewControllerDelegate: class {
    func didChoose(sortEntity: SortEntity)
}

class WalletsListViewController: BaseTableViewController {
    
    enum Mode {
        case `default`
        case select
    }
    
    // MARK: - Variables public
    
    weak var delegate: WalletsListViewControllerDelegate?
    
    // MARK: - Variables private
    
    private let viewModel = WalletsListViewModel()
    private let mode: Mode
    
    // MARK: - Initialiers
    
    init(mode: Mode, selectedEntity: SortEntity?) {
        
        self.mode = mode
        self.viewModel.selectedEntity = selectedEntity
        
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("WalletsListViewController")
    }
    
    // MARK: - Lifefycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // data
        
        loadData()
    }
    
    // MARK: - Navigations
    
    override func createLeftNavButton() -> UIBarButtonItem? {
        UIBarButtonItemFabric.close { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func createRightNavButton() -> UIBarButtonItem? {
        UIBarButtonItemFabric.add { [unowned self] in
            self.navigationController?.pushViewController(WalletAddViewController(), animated: true)
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        
        // title
        
        navigationItem.title = "Select Wallet"
        
        // UI
        
        tableView.backgroundColor = .mainBackground
        
        //table view
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .mainBackground
    
        tableView.separatorColor = .tableSeparator
        tableView.register(WalletsTotalTableViewCell.self)
        tableView.register(WalletTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadData() {
        viewModel.loadData()
        tableView.reloadData()
    }
}

extension WalletsListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        
        switch section.type {
        case .total: return 1
        case .wallets(wallets: let wallets): return wallets.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .total:
            let cell: WalletsTotalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.showBalance(viewModel.totalBalance(), isSelected: viewModel.isSelected(indexPath: indexPath))
            
            return cell
        case .wallets(wallets: let wallets):
            let cell: WalletTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            let wallet = wallets[indexPath.row]
            
            cell.apply(wallet, isSelected: viewModel.isSelected(indexPath: indexPath))
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .total:
            
            if mode == .select {
                viewModel.selectedEntity = .total
                tableView.reloadData()
                delegate?.didChoose(sortEntity: .total)
            }
            
        case .wallets(wallets: let wallets):
            viewModel.selectedEntity = .wallet(entity: wallets[indexPath.row])
            tableView.reloadData()
            delegate?.didChoose(sortEntity: .wallet(entity: wallets[indexPath.row]))
        }
    }

}
