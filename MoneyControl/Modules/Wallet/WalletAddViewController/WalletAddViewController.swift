//
//  WalletAddViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 14.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class WalletAddViewController: BaseTableViewController {
    
    // MARK: - Variables private
    
    private let viewModel = WalletAddViewModel()
    
    // ui
    
    private var nameField: UITextField! {
        didSet {
            nameField?.becomeFirstResponder()
        }
    }
    
    // MARK: - Lifefycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load data
        
        viewModel.loadData()
    }
    
    // navigation
    
    override func createRightNavButton() -> UIBarButtonItem? {
        let barItem = UIBarButtonItemFabric.add { [unowned self] in
            guard let name = self.nameField?.text else { return }
            
            self.viewModel.createWallet(name: name, currency: .uah, startBalance: 0)
        }
        
//        barItem.isEnabled = false
        
        return barItem
    }
    
    
    // MARK: - Private methods
    
    private func setup() {
        
        // title
        
        navigationItem.title = "Add Wallet"
        
        // table view
        
        configureTableView()
        
        // view model
        viewModel.delegate = self
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .mainBackground
    
        tableView.separatorColor = .tableSeparator
        tableView.register(WalletAddNameTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension WalletAddViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .name:
            let cell: WalletAddNameTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            nameField = cell.getNameField()
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }
}

extension WalletAddViewController: WalletAddViewModelDelegate {
    func didCreateWallet() {
        self.navigationController?.popViewController(animated: true)
    }
}
