//
//  SettingsViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 21.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var closeBtn: UIButton!
    
    // MARK: - Variables private
    private let viewModel = HistoryViewViewModel()
    private var topViewController: HistoryTopViewController!
    private var bottomViewController: HistoryBottomViewController!
    
    // MARK: - Lifefycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // navbar preparаtion
    override func createLeftNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.titledBarButtonItem(title: "Settings".localized)
    }
    
    // MARK: - Private methods
    private func setup() {
        //events
        subscribeToEvents()
        
        //load data
        viewModel.loadData()
    }
    
    private func subscribeToEvents() {
        closeBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            Router.instance.goBack()
        }).disposed(by: disposeBag)
    }

}
