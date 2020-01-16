//
//  HistoryViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/25/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {

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
        return UIBarButtonItemFabric.titledBarButtonItem(title: "History".localized)
    }
    
    // MARK: - Private methods
    private func setup() {
        //events
        subscribeToEvents()
        
        //child controllers
        configureChildControllers()
        
        //load data
        viewModel.loadData()
    }
    
    private func subscribeToEvents() {
        closeBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            Router.instance.goBack()
        }).disposed(by: disposeBag)
    }
    
    private func configureChildControllers() {
        guard let topController = children.first as? HistoryTopViewController else {
            fatalError("Check storyboard for top view controller")
        }
        
        guard let bottomController = children.last as? HistoryBottomViewController else {
            fatalError("Check storyboard for bottom view controller")
        }
        
        topViewController = topController
        topViewController.parentViewModel = viewModel
        
        bottomViewController = bottomController
        bottomViewController.parentViewModel = viewModel
        
    }

}
