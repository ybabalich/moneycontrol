//
//  DayViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ValidTextField: UITextField {
    
    // MARK: - Variables
    var valid: Bool = false
    
}

class DayViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: ValidTextField!
    @IBOutlet weak var loginTextField: ValidTextField!
    @IBOutlet weak var addBtn: UIButton!
    
    // MARK: - Variables
    var viewModel = DayViewViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        registerCells()
        configureTableView()
        
        //button
        addBtn.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                
                let newCirculation = Circulation(value: 100, currency: .usd, type: .incoming, category: Category(title: "Category 1", image: UIImage()), entity: .card(name: "Mono"))
                strongSelf.viewModel.history.value.append(newCirculation)
            }
            .disposed(by: disposeBag)
        
        //textfield
        let textFiedlValid =
            textField.rx.text.asObservable()
            .distinctUntilChanged()
            .throttle(1, scheduler: MainScheduler.instance)
                .map { self.validatePassword(text: $0!) }
        
        textFiedlValid.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        loginTextField.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .throttle(1, scheduler: MainScheduler.instance)
            .subscribe { (text) in
                print()
            }
            .disposed(by: disposeBag)
        
        let everythingValid = Observable
            .combineLatest(textFiedlValid, textFiedlValid) {
                $0 && $1 //All must be true
        }
        
        everythingValid
            .bind(to: addBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    private func validatePassword(text: String) -> Bool {
        return text.count > 10
    }
    
    private func validateLogin(text: String) -> Bool {
        return text.count > 0
    }
    
    private func registerCells() {
        let historyCell = UINib(nibName: String(describing: DayViewTableViewCell.self), bundle: nil)
        tableView.register(historyCell, forCellReuseIdentifier: String(describing: DayViewTableViewCell.self))
    }
    
    private func configureTableView() {
        viewModel.history.asDriver()
            .drive(tableView.rx.items(cellIdentifier: DayViewTableViewCell.cellIdentifier)) { _, money, cell in
                (cell as! DayViewTableViewCell).configure(money)
            }
            .disposed(by: disposeBag)
        
    }
}
