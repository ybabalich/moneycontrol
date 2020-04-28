//
//  SettingsViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 21.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsViewController: BaseTableViewController {

    // MARK: - Outlets
    @IBOutlet weak var closeBtn: UIButton!
//    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables private
    
    private let viewModel = SettingsViewModel()
    
    // MARK: - Lifefycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func updateLocalization() {
        super.updateLocalization()
        
        setupNavigationBarItems()
        reloadData()
    }
    
    // navbar preparаtion
    override func createRightNavButton() -> UIBarButtonItem? {
        UIBarButtonItemFabric.titledBarButtonItem(title: "Settings".localized,
                                                  fontSize: UIScreen.isSmallDevice ? 14 : 22)
    }
    
    // MARK: - Private methods
    private func setup() {
        
        //table view
        
        configureTableView()
        
        //reload data
        
        reloadData()
    }
    
    private func reloadData() {
        viewModel.loadData()
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .mainBackground
    
        tableView.separatorColor = .tableSeparator
        tableView.register(SettingsViewTitledCell.self)
        tableView.registerHeaderFooterNib(type: SettingsViewHeaderCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: SettingsViewHeaderCell = tableView.dequeueReusableHeaderFooter()
        view.titleLabel.text = viewModel.header(at: section).title
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsViewTitledCell = tableView.dequeueReusableCell(for: indexPath)
        
        let cellViewModel = viewModel.viewModelForRow(at: indexPath.section, for: indexPath.row)
        
        cell.apply(title: cellViewModel.title)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.headersCount()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.viewModelForRow(at: indexPath.section, for: indexPath.row)
        
        switch cellViewModel.type {
        case .changeLanguage:
            Router.instance.showSettingsChangeLanguageScreen()
        default: return
        }
    }
}
