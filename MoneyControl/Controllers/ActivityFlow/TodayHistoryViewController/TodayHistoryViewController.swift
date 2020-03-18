//
//  TodayHistoryViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift
import Then
import SnapKit

class TodayHistoryViewController: BaseViewController {

    typealias Segment = TodayHistoryViewViewModel.Segment
    
    // MARK: - UI
    
    private var tableView: UITableView!
    private var closeBtn: UIButton!
    private var segmentControl: UISegmentedControl!
    private var emptyView: EmptyView!
    
    // MARK: - Variables private
    
    private var initialSegment: Segment = .all
    private var viewModel = TodayHistoryViewViewModel()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        
        setupUI()
        
        // load data
        
        viewModel.loadData(for: initialSegment)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isFirstLoad {
            viewModel.loadData(for: initialSegment)
        }
    }
    
    override func createRightNavButton() -> UIBarButtonItem? {
        UIBarButtonItemFabric.titledBarButtonItem(title: "Activity".localized,
                                                  fontSize: UIScreen.main.isScreenWidthSmall ? 14 : 22)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        
        //colors
        
        view.backgroundColor = .mainBackground
        
        segmentControl = UISegmentedControl(items: Segment.allCasesLocalized).then { segmentControl in
            view.addSubview(segmentControl)
            
            segmentControl.selectedSegmentIndex = initialSegment.index
            
            segmentControl.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.centerX.equalToSuperview()
            }
        }
        
        tableView = UITableView().then { tableView in
            view.addSubview(tableView)
            
            tableView.backgroundColor = .mainElementBackground
            tableView.separatorColor = .tableSeparator
            tableView.registerNib(type: TodayHistoryTableViewCell.self)
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.applyCornerRadius(20, topLeft: true, topRight: true,
                                        bottomRight: false, bottomLeft: false)
            
            tableView.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(segmentControl.snp.bottom).offset(24)
            }
        }
        
        emptyView = EmptyView.view().then { emptyView in
            view.addSubview(emptyView)
            
            emptyView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        //events
        subscribeToEvents()
        
        //table view
        configureTableView()
    }
    
    private func subscribeToEvents() {
//        closeBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
//            Router.instance.goBack()
//        }).disposed(by: disposeBag)
        
        segmentControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] value in

            self.initialSegment = Segment(index: self.segmentControl.selectedSegmentIndex)
            self.viewModel.loadData(for: self.initialSegment)
        }).disposed(by: disposeBag)
        
        viewModel.transactions.asObservable().map({ $0.count > 0 })
            .subscribe(onNext: { [unowned self] (haveTransactions) in
            
                if haveTransactions {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                } else {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                    self.emptyView.setTitleText("Haven't activities today".localized)
                    self.emptyView.setButtonText("Add new activity".localized)
                }
                
        }).disposed(by: disposeBag)
        
        emptyView.onActionBtnTap {
            Router.instance.goBack()
        }
    }
    
    private func configureTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        viewModel.transactions.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: TodayHistoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel)
            cell.onTap(completion: { (transactionViewModel) in
                Router.instance.showEditTransactionScreen(transactionViewModel)
            })
            
            return cell
        }.disposed(by: disposeBag)
    }

}

extension TodayHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove".localized) { [unowned self] (action, indexPath) in
            let transaction = self.viewModel.transactions.value[indexPath.row]
            self.viewModel.remove(transaction)
        }
        return [deleteAction]
    }
}
