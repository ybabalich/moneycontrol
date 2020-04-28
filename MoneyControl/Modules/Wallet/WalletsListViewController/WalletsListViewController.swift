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
            let vc = WalletAddViewController(state: .add)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        
        // navigation
        
        navigationItem.title = "wallets.list.title".localized
        navigationController?.navigationBar.applyTitleStyle()
        
        // UI
        
        tableView.backgroundColor = .mainBackground
        
        //table view
        
        configureTableView()
        
        // view model
        
        viewModel.delegate = self
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .mainBackground
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
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
    
    private func showEditVC(for indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .wallets(wallets: let wallets):
            let wallet = wallets[indexPath.row]
            
            let vc = WalletAddViewController(state: .edit(entity: wallet))
            navigationController?.pushViewController(vc, animated: true)
        default: return
        }
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard !viewModel.isSelected(indexPath: indexPath) else { return nil }
        
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .total: return nil
        case .wallets(wallets: let wallets):
            let wallet = wallets[indexPath.row]
            
            let editAction = UITableViewRowAction(style: .default, title: "general.edit".localized) { [unowned self] action, indexPath in
                self.showEditVC(for: indexPath)
            }
            
            let deleteAction = UITableViewRowAction(style: .default, title: "general.delete".localized) { [unowned self] action, indexPath in
                self.viewModel.delete(entity: wallet)
            }
            
            return [deleteAction, editAction]
        }
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard !viewModel.isSelected(indexPath: indexPath) else { return nil }
        
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .total: return nil
        case .wallets(wallets: let wallets):
            let wallet = wallets[indexPath.row]
        
            let deleteAction = UIContextualAction(style: .destructive, title: "general.delete".localized) { [unowned self] _, _, completion in
                self.viewModel.delete(entity: wallet)
                completion(true)
            }
            deleteAction.backgroundColor = .controlTintDestructive
            
            if #available(iOS 13.0, *) {
                deleteAction.image = UIImage(systemName: "trash.fill")
            }

            let editAction = UIContextualAction(style: .destructive, title: "general.edit".localized) { [unowned self] _, _, completion in
                self.showEditVC(for: indexPath)
                completion(true)
            }
            editAction.backgroundColor = .controlTintEdit
            
            if #available(iOS 13.0, *) {
                editAction.image = UIImage(systemName: "pencil")
            }

            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }
    }
    
    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {

        guard !viewModel.isSelected(indexPath: indexPath) else { return nil }
        
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .wallets(wallets: let wallets):
            let wallet = wallets[indexPath.row]
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [unowned self] _ in

                let delete = UIAction(
                    title: "general.confirmDelete".localized,
                    image: UIImage(systemName: "trash.fill"),
                    attributes: .destructive) { [unowned self] _ in
                        
                        self.viewModel.delete(entity: wallet)
                }
                
                let deleteMenu = UIMenu(
                    title: "general.delete".localized,
                    image: UIImage(systemName: "trash.fill"),
                    options: .destructive,
                    children: [delete]
                )
                
                let edit = UIAction(
                    title: "general.edit".localized,
                    image: UIImage(systemName: "pencil")) { [unowned self] _ in
                        
                        self.showEditVC(for: indexPath)
                }

                return UIMenu(title: "", children: [edit, deleteMenu])
            }
        default: return nil
        }
    }
}

extension WalletsListViewController: WalletsListViewModelDelegate {
    func didSelect(sortEntity: SortEntity) {
        
    }
    
    func didUpdate() {
        loadData()
    }
}
