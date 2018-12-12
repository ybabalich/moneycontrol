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
    
    private let editAmountView = EditTransactionAmountView.view()
    private let editCategoryView = EditTransactionCategoryView.view()
    private let editDateView = EditTransactionDateView.view()
    
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
            self.viewModel.updateTransaction(value: Double(self.editAmountView.text) ?? 0,
                                             categoryId: self.editCategoryView.category.id)
        }).disposed(by: disposeBag)
        
        deleteBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.viewModel.removeTransaction()
        }).disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        viewModel.transaction.subscribe(onNext: { [unowned self] (transaction) in
            self.title = "Edit " + "\(transaction.type == .incoming ? "incoming" : "expense")"
            
            self.editAmountView.text = String(format: "%3.2f", transaction.value)
            self.editCategoryView.category = transaction.category
        }).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { (isSuccess) in
            if isSuccess {
                Router.instance.goBack()
            }
        }).disposed(by: disposeBag)
    }
}
