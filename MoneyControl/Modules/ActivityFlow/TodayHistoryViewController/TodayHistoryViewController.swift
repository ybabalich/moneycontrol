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
    
    private var titleView: ActivityTitleView!
    
    // MARK: - Variables private
    
    private var initialSegment: Segment = .all
    private var viewModel = TodayHistoryViewViewModel()
    private var oldFrame: CGRect = .zero
    
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if oldFrame != tableView.frame {
            tableView.applyCornerRadius(20, topLeft: true, topRight: true,
                                        bottomRight: false, bottomLeft: false)
            
            oldFrame = tableView.frame
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        //colors
        
        view.backgroundColor = .mainBackground
        
        titleView = ActivityTitleView().then { titleView in
            
            if !isLessThenIOS11() {
                titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
                titleView.sizeToFit()
            }
            
            navigationItem.titleView = titleView
        }
        
        segmentControl = UISegmentedControl(items: Segment.allCasesLocalized).then { segmentControl in
            view.addSubview(segmentControl)
            
            segmentControl.selectedSegmentIndex = initialSegment.index
            segmentControl.applyStyle()
            
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
        segmentControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] value in

            self.initialSegment = Segment(index: self.segmentControl.selectedSegmentIndex)
            self.viewModel.loadData(for: self.initialSegment)
        }).disposed(by: disposeBag)
        
        viewModel.transactions.asObservable().map({ $0.count > 0 })
            .subscribe(onNext: { [unowned self] (haveTransactions) in
            
                self.updateUI()
                
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
    
    private func updateUI() {
        guard let wallet = viewModel.getCurrentWallet() else { return }
        
        titleView.show(sortEntity: .wallet(entity: wallet))
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
