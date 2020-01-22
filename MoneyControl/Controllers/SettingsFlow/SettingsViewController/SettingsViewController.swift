//
//  SettingsViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 21.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables private
    private let viewModel = SettingsViewModel()
    private var topViewController: HistoryTopViewController!
    private var bottomViewController: HistoryBottomViewController!
    
    // MARK: - Lifefycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // navbar preparаtion
    override func createLeftNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.titledBarButtonItem(title: "Settings".localized)
    }
    
    // MARK: - Private methods
    private func setup() {
        //events
        subscribeToEvents()
        
        //table view
        configureTableView()
    }
    
    private func subscribeToEvents() {
        closeBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            Router.instance.goBack()
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.registerNib(type: SettingsViewTitledCell.self)
        tableView.registerHeaderFooterNib(type: SettingsViewHeaderCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooter(type: SettingsViewHeaderCell.self)
        view.titleLabel.text = viewModel.header(at: section).title
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SettingsViewTitledCell.self, indexPath: indexPath)
        
        let cellViewModel = viewModel.row(at: indexPath.section, for: indexPath.row)
        
        cell.titleLabel.text = cellViewModel.title
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.headersCount()
    }
}
