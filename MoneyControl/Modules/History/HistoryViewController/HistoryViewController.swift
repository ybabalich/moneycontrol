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
    
    private let viewModel = HistoryViewViewModel()

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
        guard let wallet = viewModel.getCurrentWallet() else { return nil }
        
        return UIBarButtonItemFabric.wallet(wallet: wallet) { [unowned self] in
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
        
        viewModel.transactions.asObservable().bind(to: tableView.rx.items) { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: TodayHistoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            cell.onTap(completion: { [weak self] (transaction) in
                guard let strongSelf = self else { return }
                
//                let historyViewModel = HistoryViewModel(sortCategory: strongSelf.viewModel.selectedSortCategory.value,
//                                                        category: transaction.category)
//                Router.instance.showTransactionsList(historyViewModel)
            })
            
            return cell
        }.disposed(by: disposeBag)
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
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.rx.setDelegate(self).disposed(by: disposeBag)
            
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
        guard let wallet = viewModel.getCurrentWallet() else { return }
        
        setupNavigationBarItems()
        titleView.show(wallet: wallet)
        balancePreviewView.apply(wallet, sort: viewModel.selectedSort.value)
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "Remove".localized) { [unowned self] (action, indexPath) in
            let transactionViewModel = self.viewModel.transactions.value[indexPath.row]
            self.viewModel.removeInnerTransactions(transactionViewModel)
        }
        return [removeAction]
    }
}

extension HistoryViewController: WalletsListViewControllerDelegate {
    func didChoose(sortEntity: SortEntity) {
        viewModel.selectedSortEntity.value = sortEntity
        updateUI()
    }
}

