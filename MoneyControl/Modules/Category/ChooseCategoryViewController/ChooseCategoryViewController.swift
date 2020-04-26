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
        
        // navigation
        
        title = "Choose Category".localized
        navigationController?.navigationBar.applyTitleStyle()
        
        // view model
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // UI
        
        setupUI()
        
        // load data
        
        viewModel.loadData()
    }
    
    // navigation
    
    override func createLeftNavButton() -> UIBarButtonItem? {
        UIBarButtonItemFabric.close { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        //colors
        
        view.backgroundColor = .mainBackground
        
        tableView = UITableView().then { tableView in
            view.addSubview(tableView)
            
            tableView.backgroundColor = .mainElementBackground
            tableView.separatorColor = .tableSeparator
            tableView.registerNib(type: ChooseCategoryTableViewCell.self)
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
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
