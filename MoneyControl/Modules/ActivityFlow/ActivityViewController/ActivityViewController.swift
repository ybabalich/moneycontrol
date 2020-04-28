//
//  ActivityViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift
import RxGesture

class ActivityViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var doneBtn: CheckButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    // MARK: - Variables private
    
    private var viewModel = ActivityViewViewModel()
    
    // UI
    
    private var topViewController: ActivityTopViewController!
    private var bottomViewController: ActivityBottomViewController!
    private var titleView: ActivityTitleView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isFirstLoad {
            viewModel.loadData()
        }
        
        updateNavigation()
    }
    
    override func updateLocalization() {
        super.updateLocalization()
        
        setupNavigationBarItems()
    }
    
    // navbar preparаtion
    
    override func createLeftNavButton() -> UIBarButtonItem? {
        guard let wallet = viewModel.getCurrentWallet() else { return nil }
        
        return UIBarButtonItemFabric.entity(sortEntity: .wallet(entity: wallet)) { [unowned self] in
            self.showWalletsListVC()
        }
    }
    
    override func createRightNavButton() -> UIBarButtonItem? {
        return UIBarButtonItemFabric.chartBarItem {
            Router.instance.showHistoryScreen()
        }
    }
    
    override func createRightNavButtonsAdditionals() -> [UIBarButtonItem]? {
//        let settingsBtn = UIBarButtonItemFabric.settingsBarItem {
//            Router.instance.showSettingsScreen()
//        }
//
//        return [settingsBtn]
        
        return nil
    }
    
    // MARK: - Private methods
    private func setup() {
        //colors
        
        bottomView.backgroundColor = .mainElementBackground
        view.backgroundColor = .mainElementBackground
        
        //images
        
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 30)
            let historyImage = UIImage(systemName: "clock.fill", withConfiguration: configuration)
            historyBtn.setImage(historyImage, for: .normal)
        }
        
        historyBtn.tintColor = .controlTintActive
        
        // ui
        
        setupUI()

        //events
        subscribeToEvents()
        
        //child controllers
        configureChildControllers()
        
        //view model
        setupViewModel()
        
        //data
        viewModel.loadData()
    }
    
    private func setupUI() {
        
        titleView = ActivityTitleView().then { titleView in
            
            if !isLessThenIOS11() {
                titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
                titleView.sizeToFit()
            }
            
            navigationItem.titleView = titleView
        }
    }
    
    private func setupViewModel() {
        viewModel.transactionType.asObservable().subscribe(onNext: { [unowned self] (transactionType) in
            if transactionType == .incoming {
                self.doneBtn.colorType = .incoming
//                self.totalLabel.textColor = App.Color.incoming.rawValue
            } else {
                self.doneBtn.colorType = .outcoming
//                self.totalLabel.textColor = App.Color.outcoming.rawValue
            }
        }).disposed(by: disposeBag)
        
        viewModel.isActiveDoneButton.bind(to: doneBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func subscribeToEvents() {
        historyBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            Router.instance.showTodayHistoryScreen()
        }).disposed(by: disposeBag)
        
        doneBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.viewModel.saveTransaction()
            self.updateNavigation()
        }).disposed(by: disposeBag)
    }
    
    private func configureChildControllers() {
        guard let topController = children.first as? ActivityTopViewController else {
            fatalError("Check storyboard for top view controller")
        }
        
        guard let bottomController = children.last as? ActivityBottomViewController else {
            fatalError("Check storyboard for bottom view controller")
        }
        
        topViewController = topController
        topViewController.parentViewModel = viewModel
        
        bottomViewController = bottomController
        bottomViewController.parentViewModel = viewModel
        
    }
    
    private func updateNavigation() {
        guard let wallet = viewModel.getCurrentWallet() else { return }
        
        setupNavigationBarItems()
        titleView.show(sortEntity: .wallet(entity: wallet))
    }
    
    private func showWalletsListVC() {
        let vc = WalletsListViewController(mode: .default, selectedEntity: viewModel.getCurrentSortEntity())
        vc.delegate = self
        let navigation = UINavigationController(rootViewController: vc)
        navigationController?.present(navigation, animated: true, completion: nil)
    }
}

extension ActivityViewController: WalletsListViewControllerDelegate {
    func didChoose(sortEntity: SortEntity) {
        switch sortEntity {
        case .wallet(entity: let entity):
            settings.wallet = entity.id
            updateNavigation()
        default: break
        }
    }
}
