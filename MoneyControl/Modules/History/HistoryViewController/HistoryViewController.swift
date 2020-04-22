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
    
    // pickers
    
    private var bottomOverlayVC: BottomOverlayViewController!
    private var calendarPickerView: HistoryCalendarPickerView!
    private var datePickerView: HistoryDatePickerView!
    
    
    // MARK: - Lifefycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
        
        // view model
        
        setupViewModel()
        
        //load data
        
        viewModel.delegate = self
        viewModel.loadData()
        
        updateUI()
    }
    
    private func setupViewModel() {
        
        viewModel.selectedSort.asObservable().subscribe(onNext: { [unowned self] _ in
            self.updateUI()
        }).disposed(by: disposeBag)
        
        viewModel.statisticsValues.asObserver().subscribe(onNext: { [unowned self] (values) in
            let (balance, incomesValue, outcomesValue) = values
            
            self.balancePreviewView.showInfo(transactionType: .incoming, double: incomesValue)
            self.balancePreviewView.showInfo(transactionType: .outcoming, double: outcomesValue)
        }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        
        // background color
        
        view.backgroundColor = .mainBackground
        
        // UI
        
        titleView = ActivityTitleView().then { titleView in
            
            navigationItem.titleView = titleView
        }
        
        balancePreviewView = BalancePreviewView().then { balancePreviewView in

            balancePreviewView.onTapChooseSort { [unowned self] in
                self.showDatePicker()
            }
            
            view.addSubview(balancePreviewView)
            balancePreviewView.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
            }
        }
        
        bottomOverlayVC = BottomOverlayViewController(contentHeight: 0)
        
        calendarPickerView = HistoryCalendarPickerView().then { calendarPickerView in
            
            calendarPickerView.onChoose { [unowned self] sort in
                
                self.viewModel.selectedSort.value = sort
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
                    self.viewModel.selectedSort.value = sort
                    self.bottomOverlayVC.closeController()
                }
            }
        }
        
        tableView = UITableView().then { tableView in
            view.addSubview(tableView)
            
            tableView.applyCornerRadius(15, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
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
        
        datePickerView.selectedSort = viewModel.selectedSort.value
        
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
        balancePreviewView.apply(sort: viewModel.selectedSort.value)
    }
}

extension HistoryViewController: WalletsListViewControllerDelegate {
    func didChoose(sortEntity: SortEntity) {
        viewModel.selectedSortEntity.value = sortEntity
        updateUI()
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    func didReceiveUpdates(insertions: [IndexPath], removals: [IndexPath]) {
        
    }
    
    func didReceiveUpdatesForSections(insertions: IndexSet, removals: IndexSet) {
        if #available(iOS 11.0, *) {
            tableView.performBatchUpdates({
                tableView.insertSections(insertions, with: .automatic)
                tableView.deleteSections(removals, with: .automatic)
            }, completion: nil)
        } else {
            tableView.beginUpdates()
            tableView.insertSections(insertions, with: .automatic)
            tableView.deleteSections(removals, with: .automatic)
            tableView.endUpdates()
        }
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
}

