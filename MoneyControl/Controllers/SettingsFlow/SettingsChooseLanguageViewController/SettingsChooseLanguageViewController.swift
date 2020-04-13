//
//  SettingsChooseLanguageViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 23.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsChooseLanguageViewController: BaseTableViewController {
    
    // MARK: - Variables private
    private let viewModel = SettingsChooseLanguageViewModel()
    
    // MARK: - Initializers
    convenience init() {
        self.init(style: .plain)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("SettingsChooseLanguageViewController")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // navbar preparаtion
    override func createRightNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.titledBarButtonItem(title: "Choose language",
                                                         fontSize: UIScreen.isSmallDevice ? 14 : 22)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        
        //table view
        configureTableView()
        
        //view model
        viewModel.loadData()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.backgroundColor = .mainBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        tableView.separatorColor = .tableSeparator
        tableView.registerNib(type: SettingsChooseLanguageTitledCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SettingsChooseLanguageViewController  {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SettingsChooseLanguageTitledCell.self, indexPath: indexPath)
        
        let cellViewModel = viewModel.viewModel(for: indexPath.row)
        
        cell.apply(cellViewModel)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.viewModel(for: indexPath.row)
        viewModel.setLanguageCode(cellViewModel.languageCode)
        Router.instance.goBack()
    }
}
