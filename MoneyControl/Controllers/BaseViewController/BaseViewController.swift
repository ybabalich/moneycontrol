//
//  BaseViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class BaseViewController: UIViewController {

    // MARK: - Variables private
    internal var isFirstLoad: Bool = true
    internal var viewWillAppearLoadingCount: Int = 0
    internal let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewWillAppearLoadingCount > 0 {
            isFirstLoad = false
            
            //updates
            updateLocalization()
            updateCurrencies()
        }
        
        viewWillAppearLoadingCount += 1
    }
    
    // MARK: - Public methods
    func updateLocalization() {
        
    }
    
    func updateCurrencies() {
        
    }
    
    //navbar items
    func setupNavigationBarItems() {
        if !self.navigationItem.hidesBackButton {
            if let leftNavigationButton: UIBarButtonItem = self.createLeftNavButton() {
                if let leftNavigationButton: UIButton = leftNavigationButton.customView as? UIButton {
                    leftNavigationButton.addTarget(self, action: #selector(self.didBtNavLeftClicked), for: UIControl.Event.touchUpInside)
                } else {
                    leftNavigationButton.target = self
                    leftNavigationButton.action = #selector(self.didBtNavLeftClicked)
                }
                
                if let leftBbis: [UIBarButtonItem] = self.createLeftNavButtonsAdditionals(), !leftBbis.isEmpty {
                    var fullLeftBbis: [UIBarButtonItem] = [leftNavigationButton]
                    fullLeftBbis.append(contentsOf: leftBbis)
                    self.navigationItem.leftBarButtonItems = fullLeftBbis
                } else {
                    self.navigationItem.leftBarButtonItem = leftNavigationButton
                }
            }
        }
        
        // right nav button
        if let rightNavigationButton: UIBarButtonItem = self.createRightNavButton() {
            if let rightNavigationButton: UIButton = rightNavigationButton.customView as? UIButton {
                rightNavigationButton.addTarget(self, action: #selector(self.didBtNavRightClicked), for: UIControl.Event.touchUpInside)
            } else {
                rightNavigationButton.target = self
                rightNavigationButton.action = #selector(self.didBtNavRightClicked)
            }
            
            if let rightBbis: [UIBarButtonItem] = self.createRightNavButtonsAdditionals(), !rightBbis.isEmpty {
                var fullRightBbis: [UIBarButtonItem] = [rightNavigationButton]
                fullRightBbis.append(contentsOf: rightBbis)
                self.navigationItem.rightBarButtonItems = fullRightBbis
            } else {
                self.navigationItem.rightBarButtonItem = rightNavigationButton
            }
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        setupNavigationBarItems()
    }
    
    internal func customizeBackBtn() {
        navigationController?.navigationBar.tintColor = App.Color.main.rawValue
    }
    
    // for overriding
    func createLeftNavButton() -> UIBarButtonItem? {
        return nil
    }
    
    func createLeftNavButtonsAdditionals() -> [UIBarButtonItem]? {
        return nil
    }
    
    func createRightNavButton() -> UIBarButtonItem? {
        return nil
    }
    
    func createRightNavButtonsAdditionals() -> [UIBarButtonItem]? {
        return nil
    }
    
    func createTitleViewNavItem() -> UIView? {
        return nil
    }
    
    // navbar actions
    @objc open func didBtNavLeftClicked() {
        Router.instance.goBack()
    }
    
    @objc open func didBtNavRightClicked() {
        
    }
    
}
