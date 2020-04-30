//
//  HistoryViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {
    
    
    // MARK: - Variables private
    
    private let viewModel = HistoryViewModel()

    // UI
    
    private var titleView: ActivityTitleView!
    private var balancePreviewView: BalancePreviewView!
    private var tableView: UITableView!
    
    private var oldTableFrame: CGRect = .zero
    
    // pickers
    
    private var bottomOverlayVC: BottomOverlayViewController!
    private var calendarPickerView: HistoryCalendarPickerView!
    private var datePickerView: HistoryDatePickerView!
    
    
    // MARK: - Lifefycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        viewModel.loadData(selectedSort: viewModel.selectedSort)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if oldTableFrame != tableView.frame {
            tableView.applyCornerRadius(15, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
            oldTableFrame = tableView.frame
        }
    }
    
    // navbar preparаtion
    
    override func createRightNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.entity(sortEntity: viewModel.getCurrentSortEntity()) { [unowned self] in
            self.showWalletsListVC()
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {

        // UI
        
        setupUI()
        
        //load data
        
        viewModel.delegate = self
        
        updateUI()
    }
    
    private func setupUI() {
        
        // background color
        
        view.backgroundColor = .mainBackground
        
        // UI
        
        titleView = ActivityTitleView().then { titleView in
            
            if !isLessThenIOS11() {
                titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
                titleView.sizeToFit()
            }
            
            navigationItem.titleView = titleView
        }
        
        balancePreviewView = BalancePreviewView().then { balancePreviewView in

            balancePreviewView.onTapChooseSort { [unowned self] in
                switch self.viewModel.selectedSort {
                case .custom(from: let fromDate, to: let toDate):
                    self.showCalendarPicker(selectedDates: (fromDate, toDate))
                default: self.showDatePicker()
                }
            }
            
            view.addSubview(balancePreviewView)
            balancePreviewView.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
            }
        }
        
        bottomOverlayVC = BottomOverlayViewController(contentHeight: 0)
        
        calendarPickerView = HistoryCalendarPickerView().then { calendarPickerView in
            
            calendarPickerView.onChoose { [unowned self] sort in
                
                self.viewModel.loadData(selectedSort: sort)
                self.bottomOverlayVC.closeController()
            }
            
            calendarPickerView.onCloseTap { [unowned self] in
                self.bottomOverlayVC.closeController()
            }
            
            calendarPickerView.onBackTap { [unowned self] in
                self.showDatePicker()
            }
        }
        
        datePickerView = HistoryDatePickerView().then { datePickerView in
            
            datePickerView.onCloseTap { [unowned self] in
                self.bottomOverlayVC.closeController()
            }
            
            datePickerView.onChoose { [unowned self] sort in
                
                switch sort {
                case .custom(from: _, to: _):
                    self.showCalendarPicker(selectedDates: nil)
                default:
                    self.viewModel.loadData(selectedSort: sort)
                    self.bottomOverlayVC.closeController()
                }
            }
        }
        
        tableView = UITableView().then { tableView in
            view.addSubview(tableView)
            
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 51
            tableView.backgroundColor = .mainElementBackground
            tableView.separatorColor = .tableSeparator
            tableView.registerNib(type: TodayHistoryTableViewCell.self)
            tableView.registerHF(HistoryTableHeaderView.self)
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(balancePreviewView.snp.bottom).offset(16)
            }
        }
    }
    
    private func showDatePicker() {
        if bottomOverlayVC.presentingViewController == nil {
            present(bottomOverlayVC, animated: true, completion: nil)
        }
    
        func pickerHeight() -> CGFloat {
            if UIApplication.isDeviceWithSafeArea {
                return UIScreen.isSmallDevice ? 240 : 270
            } else {
                return UIScreen.isSmallDevice ? 215 : 230
            }
        }
        
        datePickerView.selectedSort = viewModel.selectedSort
        
        bottomOverlayVC.showContentView(datePickerView)
        bottomOverlayVC.changeContentHeight(pickerHeight())
    }
    
    private func showCalendarPicker(selectedDates: Calendar.StartEndDate?) {
        if bottomOverlayVC.presentingViewController == nil {
            present(bottomOverlayVC, animated: true, completion: nil)
        }
        
        func pickerHeight() -> CGFloat {
            if UIApplication.isDeviceWithSafeArea {
                return UIScreen.isSmallDevice ? 370 : 400
            } else {
                return UIScreen.isSmallDevice ? 350 : 380
            }
        }
        
        bottomOverlayVC.showContentView(calendarPickerView)
        bottomOverlayVC.changeContentHeight(pickerHeight())
        calendarPickerView.selectedDates = selectedDates
    }
    
    private func showWalletsListVC() {
        let vc = WalletsListViewController(mode: .select, selectedEntity: viewModel.getCurrentSortEntity())
        vc.delegate = self
        let navigation = UINavigationController(rootViewController: vc)
        navigationController?.present(navigation, animated: true, completion: nil)
    }
    
    private func updateUI() {
        let entity = viewModel.getCurrentSortEntity()
        
        setupNavigationBarItems()
        titleView.show(sortEntity: entity)
        balancePreviewView.apply(sort: viewModel.selectedSort)
    }
    
    private func showEditScreen(for indexPath: IndexPath) {
        let transactionVM = viewModel.sections[indexPath.section].transactions[indexPath.row]
        Router.instance.showEditTransactionScreen(transactionVM)
    }
    
    private func removeTransaction(for indexPath: IndexPath, withConfirmFlow: Bool) {
        let transactionVM = viewModel.sections[indexPath.section].transactions[indexPath.row]
        
        if !withConfirmFlow {
            viewModel.removeTransaction(transactionVM)
            updateUI()
        } else {
            
            let yesAction = AlertAction(title: "Yes", style: .destructive)
            let noAction = AlertAction(title: "No", style: .default)
            
            Alert.show(title: "Remove transaction",
                       message: nil, actions: [yesAction, noAction],
                       in: self) { [unowned self] alert in
                        
                        if alert == yesAction {
                            self.removeTransaction(for: indexPath, withConfirmFlow: false)
                        }
            }
            
        }
    }
}

extension HistoryViewController: WalletsListViewControllerDelegate {
    func didChoose(sortEntity: SortEntity) {
        viewModel.selectedSortEntity = sortEntity
        viewModel.loadData(selectedSort: viewModel.selectedSort)
        updateUI()
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    func didChooseDate(title: String) {
        
    }
    
    func didReceiveUpdates(insertions: [IndexPath], removals: [IndexPath], updates: [IndexPath]) {
        
        func performUpdates() {
            if !removals.isEmpty {
                tableView.deleteRows(at: removals, with: .fade)
            }
            
            if !insertions.isEmpty {
                tableView.insertRows(at: insertions, with: .fade)
            }
            
            if !updates.isEmpty {
                tableView.reloadRows(at: updates, with: .fade)
            }
            
            Set((insertions + removals + updates).compactMap { $0.section }).forEach { section in
                guard let header = tableView.headerView(forSection: section) as? HistoryTableHeaderView else { return }
                
                header.apply(section: viewModel.sections[section])
            }
        }
        
        if #available(iOS 11.0, *) {
            tableView.performBatchUpdates({
                performUpdates()
            }, completion: nil)
        } else {
            tableView.beginUpdates()
            performUpdates()
            tableView.endUpdates()
        }
    }
    
    func didReceiveUpdatesForSections(insertions: IndexSet, removals: IndexSet) {
        
        func performUpdates() {
            if insertions.count > 0 {
                self.tableView.insertSections(insertions, with: .fade)
            }
            
            if removals.count > 0 {
                self.tableView.deleteSections(removals, with: .fade)
            }
        }
        
        if #available(iOS 11.0, *) {
            tableView.performBatchUpdates({
                performUpdates()
            }, completion: nil)
        } else {
            tableView.beginUpdates()
            performUpdates()
            tableView.endUpdates()
        }
    }
    
    func didCalculate(incomes: Double, outcomes: Double) {
        balancePreviewView.showInfo(transactionType: .incoming, double: incomes)
        balancePreviewView.showInfo(transactionType: .outcoming, double: outcomes)
    }
    
    func didSelectSort(selectedSort: Sort) {
        updateUI()
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TodayHistoryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let transactionVM = viewModel.sections[indexPath.section].transactions[indexPath.row]
        
        cell.apply(transactionVM)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: HistoryTableHeaderView = tableView.dequeueReusableHeaderFooter()
        
        header.apply(section: viewModel.sections[section])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction = UITableViewRowAction(style: .default,
                                              title: "general.edit".localized) { [unowned self] action, indexPath in
                                                
                                                self.showEditScreen(for: indexPath)
        }
        
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "general.delete".localized) { [unowned self] action, indexPath in
                                                    
                                                self.removeTransaction(for: indexPath, withConfirmFlow: true)
        }
        
        return [deleteAction, editAction]
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "general.delete".localized) { [unowned self] _, _, completion in
                                                
                                                self.removeTransaction(for: indexPath, withConfirmFlow: true)
                                                completion(true)
        }
        deleteAction.backgroundColor = .controlTintDestructive
        
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash.fill")
        }

        let editAction = UIContextualAction(style: .destructive, title: "general.edit".localized) { [unowned self] _, _, completion in
            self.showEditScreen(for: indexPath)
            completion(true)
        }
        editAction.backgroundColor = .controlTintEdit
        
        if #available(iOS 13.0, *) {
            editAction.image = UIImage(systemName: "pencil")
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [unowned self] _ in

            let delete = UIAction(
                title: "general.confirmDelete".localized,
                image: UIImage(systemName: "trash.fill"),
                attributes: .destructive) { [unowned self] _ in
                    
                    self.removeTransaction(for: indexPath, withConfirmFlow: false)
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
                    
                    self.showEditScreen(for: indexPath)
            }

            return UIMenu(title: "", children: [edit, deleteMenu])
        }
    }
}

