//
//  EditTransactionViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class EditTransactionViewController: BaseTableViewController {

    // MARK: - UI
    
    private var dateTextField: UITextField!
    private let datePicker = UIDatePicker()
    private var saveBarItem: UIBarButtonItem?
    
    // MARK: - Variables private
    
    private var viewModel: EditTransactionViewModel!
    
    
    // MARK: - Initializers
    
    init(transaction: TransactionViewModel) {
        
        viewModel = EditTransactionViewModel(transaction: transaction)
        
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("EditTransactionViewController")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // navigation
    
    override func createRightNavButton() -> UIBarButtonItem? {
        saveBarItem = UIBarButtonItemFabric.save { [unowned self] in
            self.viewModel.save()
        }
        
        return saveBarItem
    }
    
    // MARK: - Private methods
    
    private func setup() {
        
        // title
        
        title = "Edit category"
        
        // table view
        
        configureTableView()
        
        // colors

        view.backgroundColor = .mainBackground
        
        // view model
        
        viewModel.delegate = self
        viewModel.loadData()
    }

    private func showDateChooseView() {
        datePicker.datePickerMode = .date

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(dateChoosed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(dateChooseCancel))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        // add toolbar to textField
        dateTextField?.inputAccessoryView = toolbar
        dateTextField?.inputView = datePicker
        dateTextField?.becomeFirstResponder()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .mainBackground
    
        tableView.separatorColor = .tableSeparator
        tableView.register(BalanceEditTableViewCell.self)
        tableView.register(CategoryEditTableViewCell.self)
        tableView.register(DateEditTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func dateChooseCancel() {
        dateTextField?.endEditing(true)
    }
    
    @objc private func dateChoosed() {
        viewModel.selectDate(datePicker.date)
    }
    
}

extension EditTransactionViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .amount:
            let cell: BalanceEditTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.getBalanceField().onChanged { [unowned self] text in
                self.viewModel.selectAmount(text.double)
            }
            
            cell.apply(amount: viewModel.filledAmount())
            
            return cell
        
        case .category:
            let cell: CategoryEditTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.apply(category: viewModel.filledCategory())
            
            return cell
            
        case .date:
            let cell: DateEditTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            dateTextField = cell.getDateField()
            cell.apply(date: viewModel.filledDate())
            
            return cell

        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = viewModel.sections[indexPath.section]
        
        switch section.type {
        case .category:
            let transaction = viewModel.transaction
            let vc = ChooseCategoryViewController(category: viewModel.filledCategory(),
                                                  selectedType: transaction.type)
            vc.delegate = self
            let nvc = UINavigationController(rootViewController: vc)
            navigationController?.present(nvc, animated: true, completion: nil)
            
        case .date:
            showDateChooseView()
            
        default: print("No need to consider")
        }
        
        
    }
}

extension EditTransactionViewController: ChooseCategoryViewControllerDelegate {
    func didChooseCategory(from controller: ChooseCategoryViewController, category: CategoryViewModel) {
        viewModel.selectCategory(category)
        controller.dismiss(animated: true, completion: nil)
    }
}

extension EditTransactionViewController: EditTransactionViewModelDelegate {
    func didChangeSaveBtnStatus(isActive: Bool) {
        saveBarItem?.isEnabled = isActive
    }
    
    func didUpdateData() {
        tableView.reloadData()
    }
    
    func didSaveData() {
        Router.instance.goBack()
    }
}
