//
//  SettingsChooseLanguageViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 23.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsChooseLanguageViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: - Variables private
    private let viewModel = SettingsChooseLanguageViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // navbar preparаtion
    override func createLeftNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.titledBarButtonItem(title: "Choose language",
                                                         fontSize: UIScreen.main.isScreenWidthSmall ? 14 : 22)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        //events
        subscribeToEvents()
        
        //table view
        configureTableView()
        
        //view model
        viewModel.loadData()
    }
    
    private func subscribeToEvents() {
        backBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            Router.instance.goBack()
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.registerNib(type: SettingsChooseLanguageTitledCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SettingsChooseLanguageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SettingsChooseLanguageTitledCell.self, indexPath: indexPath)
        
        let cellViewModel = viewModel.viewModel(for: indexPath.row)
        
        cell.apply(cellViewModel)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.viewModel(for: indexPath.row)
        viewModel.setLanguageCode(cellViewModel.languageCode)
        Router.instance.goBack()
    }
}
