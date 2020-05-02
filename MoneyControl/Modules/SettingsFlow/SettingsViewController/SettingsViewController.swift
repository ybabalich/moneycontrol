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
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title?.uppercased()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsViewTitledCell = tableView.dequeueReusableCell(for: indexPath)
        
        let row = viewModel.sections[indexPath.section].rows[indexPath.row]
        
        cell.apply(title: row.title)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
