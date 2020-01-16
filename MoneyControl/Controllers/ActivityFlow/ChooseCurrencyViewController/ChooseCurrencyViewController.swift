//
//  ChooseCurrencyViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/17/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import RxSwift

class ChooseCurrencyViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: CheckButton! {
        didSet {
            saveBtn.colorType = .incoming
        }
    }
    
    // MARK: - Variables
    private var viewModel = ChooseCurrencyViewViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        
        //tableview
        configureTableView()
        
        //load data
        viewModel.loadData()
        
        //view model
        viewModel.isActiveSaveBtn.asObservable().bind(to: saveBtn.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isSuccess.subscribe(onNext: { (isSuccess) in
            if isSuccess {
                Router.instance.showYourBalanceScreen()
            }
        }).disposed(by: disposeBag)
        
        //events
        saveBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.viewModel.save()
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.registerNib(type: ChooseCurrencyTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        
        viewModel.currencies.asObservable().bind(to: tableView.rx.items)
        { [unowned self] (tableView, row, currency) in
            let cell = tableView.dequeueReusableCell(type: ChooseCurrencyTableViewCell.self,
                                                     indexPath: IndexPath(row: row, section: 0))
            
            cell.apply(currency, isSelected: self.viewModel.selectedCurrency.value == currency)
            
            return cell
        }.disposed(by: disposeBag)
    }

}

extension ChooseCurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCurrency(indexPath)
        tableView.reloadData()
    }
}
