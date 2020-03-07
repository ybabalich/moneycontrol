//
//  ChooseCategoryViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/20/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import RxSwift
import RxDataSources

class ChooseCategoryViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet {
            if #available(iOS 13, *) {
                segmentControl.selectedSegmentTintColor = App.Color.main.rawValue
                
                let unselectedAttributes = [NSAttributedString.Key.foregroundColor: App.Color.main.rawValue];
                let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];
                
                segmentControl.setTitleTextAttributes(unselectedAttributes, for: .normal)
                segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
            } else {
                segmentControl.tintColor = App.Color.main.rawValue
            }
            
            segmentControl.setTitle("Spending".localized, forSegmentAt: 0)
            segmentControl.setTitle("Revenues".localized, forSegmentAt: 1)
        }
    }
    @IBOutlet weak var tableViewContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: CheckButton! {
        didSet {
            saveBtn.colorType = .incoming
        }
    }
    
    // MARK: - Variables private
    private let viewModel = ChooseCategoryViewViewModel()
    private var _categoryClosure: CategoryViewModelClosure?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewContentView.applyFullyRounded(15)
    }
    
    // MARK: - Public methods
    func onChooseCategory(completion: @escaping CategoryViewModelClosure) {
        _categoryClosure = completion
    }
    
    // MARK: - Private methods
    private func setup() {
        //general
        customizeBackBtn()
        title = "Choose Category".localized
        
        //events
        subscribeToEvents()
        
        //table view
        configureTableView()
        
        //view model
        setupViewModel()
    }
    
    private func subscribeToEvents() {
        segmentControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] (value) in
            let type: Transaction.TransactionType = self.segmentControl.selectedSegmentIndex == 0 ? .outcoming : .incoming
            self.viewModel.selectedTransationType.value = type
        }).disposed(by: disposeBag)
        
        saveBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            guard let selectedCategory = self.viewModel.selectedCategory.value else { return }
            
            self._categoryClosure?(selectedCategory)
            
            Router.instance.goBack()
        }).disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        //load data
        viewModel.loadData()
    }
    
    private func configureTableView() {
        tableView.registerNib(type: ChooseCategoryTableViewCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundView?.backgroundColor = .white
        tableView.backgroundColor = .white
        
        viewModel.categories.asObservable().bind(to: tableView.rx.items)
        { (tableView, row, viewModel) in
            let cell = tableView.dequeueReusableCell(type: ChooseCategoryTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(viewModel,
                       isSelected: self.viewModel.selectedCategory.value?.id == viewModel.id)
            /*cell.onTap(completion: { (transactionViewModel) in
             Router.instance.showEditTransactionScreen(transactionViewModel)
             })*/
            
            return cell
        }.disposed(by: disposeBag)
    }
    
}

extension ChooseCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(indexPath)
        tableView.reloadData()
    }
}

