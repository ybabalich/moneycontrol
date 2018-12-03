//
//  EditTransactionViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/2/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

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
        navigationController?.navigationBar.tintColor = App.Color.main.rawValue
        
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
    }
    
    private func setupViewModel() {
        viewModel.transaction.subscribe(onNext: { [unowned self] (transaction) in
            self.title = "Edit " + "\(transaction.type == .incoming ? "incoming" : "expense")"
        }).disposed(by: disposeBag)
    }
    

}
