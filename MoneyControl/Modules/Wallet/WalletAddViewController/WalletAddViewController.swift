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
    
    private var nameField: LimitedTextField! {
        didSet {
            nameField?.initialText = viewModel.prefilledName
            nameField?.becomeFirstResponder()
            
            nameField?.onChanged { [unowned self] _ in
                self.checkFieldsValidation()
            }
        }
    }
    private var balanceField: LimitedTextField! {
        didSet {
            balanceField?.onChanged { [unowned self] _ in
                self.checkFieldsValidation()
            }
        }
    }
    private var rightBarItem: UIBarButtonItem?
    
    // MARK: - Initializers
    
    init(state: WalletAddViewModel.State) {
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
        
        viewModel.state = state
    }
    
    required init?(coder: NSCoder) {
        fatalError("WalletAddViewController")
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
        
        rightBarItem = UIBarButtonItemFabric.save { [unowned self] in
            
            switch self.viewModel.state {
            case .add: self.viewModel.createWallet()
            case .edit: self.viewModel.editWallet()
            }
        }

        return rightBarItem
    }
    
    
    // MARK: - Private methods
    
    private func setup() {
        
        // title
        
        switch viewModel.state {
        case .add: navigationItem.title = "Add Wallet"
        case .edit(entity: _): navigationItem.title = "Edit Wallet"
        }
        
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
        tableView.register(WalletAddBalanceTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func checkFieldsValidation() {
        viewModel.checkValidation(name: nameField?.text, balance: balanceField?.text)
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
        case .startingBalance:
            let cell: WalletAddBalanceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            balanceField = cell.getBalanceField()
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }
}

extension WalletAddViewController: WalletAddViewModelDelegate {
    func isValidFields(_ isValid: Bool) {
        rightBarItem?.isEnabled = isValid
    }
    
    func didSuccessFinish() {
        self.navigationController?.popViewController(animated: true)
    }
}
