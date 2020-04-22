//
//  ChooseCategoryViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/20/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import RxSwift

protocol ChooseCategoryViewControllerDelegate: class {
    func didChooseCategory(from controller: ChooseCategoryViewController, category: CategoryViewModel)
}

class ChooseCategoryViewController: BaseViewController {
    
    typealias Segment = ChooseCategoryViewModel.Segment
    
    // MARK: - UI
    
    private var segmentControl: UISegmentedControl!
    private var tableView: UITableView!
    
    // MARK: - Variables public
    
    weak var delegate: ChooseCategoryViewControllerDelegate?
    
    // MARK: - Variables private
    
    private let viewModel: ChooseCategoryViewModel!
    
    // MARK: - Initializers
    
    init(category: CategoryViewModel?, selectedType: Transaction.TransactionType?) {
        
        viewModel = ChooseCategoryViewModel(category: category, selectedType: selectedType)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChooseCategoryViewController")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        
        title = "Choose Category".localized
        
        // UI
        
        setupUI()
        
        // view model
        
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.applyCornerRadius(15, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        //colors
        
        view.backgroundColor = .mainBackground
        
        segmentControl = UISegmentedControl(items: Segment.allCasesLocalized).then { segmentControl in
            view.addSubview(segmentControl)
            
            segmentControl.selectedSegmentIndex = viewModel.selectedSegmentType().index
            segmentControl.applyStyle()
            segmentControl.addTarget(self, action: #selector(didChangeSegmentControl), for: .valueChanged)
            
            segmentControl.snp.makeConstraints {
                $0.topMargin.equalToSuperview().offset(24)
                $0.centerX.equalToSuperview()
            }
        }
        
        tableView = UITableView().then { tableView in
            view.addSubview(tableView)
            
            tableView.applyCornerRadius(15, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
            tableView.backgroundColor = .mainElementBackground
            tableView.separatorColor = .tableSeparator
            tableView.registerNib(type: ChooseCategoryTableViewCell.self)
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(segmentControl.snp.bottom).offset(24)
                $0.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    @objc private func didChangeSegmentControl() {
        viewModel.selectAndFetch(for: Segment(index: segmentControl.selectedSegmentIndex))
    }
}

extension ChooseCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ChooseCategoryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let category = viewModel.categories[indexPath.row]
        
        cell.apply(category, isSelected: viewModel.isSelected(for: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didChooseCategory(from: self, category: viewModel.categories[indexPath.row])
    }
}

extension ChooseCategoryViewController: ChooseCategoryViewModelDelegate {
    func didFetchCategories() {
        tableView.reloadData()
    }
}
