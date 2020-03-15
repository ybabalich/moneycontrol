//
//  EditTransactionViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class EditTransactionViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var firstContentView: UIView!
    @IBOutlet weak var secondContentView: UIView!
    @IBOutlet weak var thirdContentView: UIView!
    @IBOutlet weak var deleteBtn: RemoveButton!
    @IBOutlet weak var saveBtn: CheckButton! {
        didSet {
            saveBtn.colorType = .incoming
        }
    }
    @IBOutlet weak var stackContentView: UIView!
    
    // MARK: - Variables public
    var transactionViewModel: TransactionViewModel! {
        didSet {
            setupViewModel()
            viewModel.applyTransaction(transactionViewModel)
        }
    }
    
    // MARK: - Variables private
    private var viewModel = EditTransactionViewViewModel()
    
    private let chooseCategoryViewController: ChooseCategoryViewController = UIViewController.by(flow: .category(viewController: .chooseCategory)) as! ChooseCategoryViewController
    private let editAmountView = EditTransactionAmountView.view()
    private let editCategoryView = EditTransactionCategoryView.view()
    private let editDateView = EditTransactionDateView.view()
    
    private let datePicker = UIDatePicker()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stackContentView.applyFullyRounded(15)
    }
    
    // MARK: - Private methods
    private func setup() {
        //navigation
        navigationItem.hidesBackButton = false
        customizeBackBtn()
        
        // colors
//        stackContentView.backgroundColor = .mainElementBackground
//        view.backgroundColor = .mainBackground
        
        //views
        setupSubviews()
    }
    
    private func setupSubviews() {
        // amount view
        firstContentView.addSubview(editAmountView)
        editAmountView.alignExpandToSuperview()
        
        // category view
        secondContentView.addSubview(editCategoryView)
        editCategoryView.alignExpandToSuperview()
        
        //date view
        thirdContentView.addSubview(editDateView)
        editDateView.alignExpandToSuperview()
        
        //events
        view.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        saveBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.viewModel.updateTransaction(value: self.editAmountView.text.numeric)
        }).disposed(by: disposeBag)
        
        deleteBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.viewModel.removeTransaction()
        }).disposed(by: disposeBag)
        
        editDateView.onTap { [unowned self] in
            self.showDateChooseView()
        }
        
        editCategoryView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            
            Router.instance.showController(strongSelf.chooseCategoryViewController)
        }
        
        chooseCategoryViewController.onChooseCategory { [weak self] (category) in
            guard let strongSelf = self else { return }
            
            strongSelf.viewModel.selectCategory(category)
        }
    }
    
    private func setupViewModel() {
        viewModel.transaction.subscribe(onNext: { [unowned self] (transaction) in
            self.title = "Edit".localized + " " + "\(transaction.type == .incoming ? "Incoming" : "Expense")".localized
            
            self.editAmountView.text = transaction.value.currencyFormatted
            self.editCategoryView.category = transaction.category
            self.editDateView.text = transaction.formattedTime
            self.datePicker.date = transaction.createdTime
        }).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { (isSuccess) in
            if isSuccess {
                Router.instance.goBack()
            }
        }).disposed(by: disposeBag)
    }

    private func showDateChooseView() {
        
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(dateChoosed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(dateChoosingCancel))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        editDateView.textField.inputAccessoryView = toolbar
        
        editDateView.textField.inputView = datePicker
        editDateView.textField.becomeFirstResponder()
    }
    
    @objc private func dateChoosed() {
        editDateView.text = DateService.instance.convertDateToString(datePicker.date, format: DateService.dayMonthYearWithSpacesFormat)
        viewModel.changeDate(to: datePicker.date)
        
        dateChoosingCancel()
    }
    
    @objc private func dateChoosingCancel() {
        editDateView.textField.resignFirstResponder()
    }
}
