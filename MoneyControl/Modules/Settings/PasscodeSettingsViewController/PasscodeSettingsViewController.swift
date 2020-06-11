//
//  PasscodeSettingsViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 02.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class PasscodeSettingsViewController: UITableViewController {

    private var viewModel: PasscodeSettingsViewModel! {
        didSet { viewModel.controller = self }
    }

    //
    // MARK: - View Lifecycle

    init() {
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
        
        self.viewModel = PasscodeSettingsViewModel()
        self.viewModel.controller = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("PasscodeSettingsViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PIN Settings"

        setupUI()
    }

    //
    // MARK: - Private Stuff

    private func setupUI() {

        tableView.do { v in

            v.dataSource = viewModel

            v.backgroundView = nil
            v.separatorColor = .tableSeparator

            v.rowHeight = 44
            v.estimatedRowHeight = 44
        }
    }
}

extension PasscodeSettingsViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = viewModel.sections[indexPath.section]
        let row = section.rows[indexPath.row]

        switch section.name {
        case .general where row == .turnOn:
            viewModel.userTappedEnablePasscode()

        case .general where row == .turnOff:
            viewModel.userTappedDisablePasscode()

        case .general where row == .changeCode:
            viewModel.userTappedChangePasscode()

        case .utilities where row == .autolock:
            viewModel.userTappedRequirePasscode()

        default: fatalError("Should not ever happen!")
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = .secondaryText
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {

        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = .secondaryText
        }
    }
}

extension PasscodeSettingsViewController: PasscodeSettingsViewModelDelegate {

    func setNeedsReloadContent() {
        tableView.reloadData()
    }
}
