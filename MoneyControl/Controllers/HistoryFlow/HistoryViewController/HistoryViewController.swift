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
    
    private let historyTitleView = HistoryTitleView()
    
    // pickers
    
    private var bottomOverlayVC: BottomOverlayViewController!
    private var calendarPickerView: HistoryCalendarPickerView!
    private var datePickerView: HistoryDatePickerView!
    
    // MARK: - Lifefycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // navbar preparаtion
    
    override func createRightNavButton() -> UIBarButtonItem? {
        UIBarButtonItemFabric.calendar { [unowned self] in
            
            switch self.viewModel.selectedSortCategory.value.sortType {
            case .custom(from: let fromDate, to: let endDate):
                self.showCalendarPicker(selectedDates: (fromDate, endDate))
            default: self.showDatePicker()
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        
        viewModel.titles.asObserver().subscribe(onNext: { [unowned self] values in
            self.historyTitleView.show(firstTitle: values.0, secondTitle: values.1)
        }).disposed(by: disposeBag)
        
        // colors
        view.backgroundColor = .mainElementBackground
        
        //child controllers
        configureChildControllers()
        
        //load data
        viewModel.loadData()
        
        // title view
    
        navigationItem.titleView = historyTitleView
        
        // UI
        
        bottomOverlayVC = BottomOverlayViewController(contentHeight: 0)
        
        calendarPickerView = HistoryCalendarPickerView().then { calendarPickerView in
            
            calendarPickerView.onChoose { [unowned self] sortCategory in
                
                self.viewModel.selectedSortCategory.value = HistorySortCategoryViewModel(sort: sortCategory)
                self.bottomOverlayVC.closeController()
            }
            
            calendarPickerView.onCloseTap { [unowned self] in
                self.bottomOverlayVC.closeController()
            }
            
            calendarPickerView.onBackTap { [unowned self] in
                self.showDatePicker()
            }
        }
        
        datePickerView = HistoryDatePickerView().then { datePickerView in
            
            datePickerView.onCloseTap { [unowned self] in
                self.bottomOverlayVC.closeController()
            }
            
            datePickerView.onChoose { [unowned self] category in
                
                switch category {
                case .custom(from: _, to: _):
                    self.showCalendarPicker(selectedDates: nil)
                default:
                    self.viewModel.selectedSortCategory.value = HistorySortCategoryViewModel(sort: category)
                    self.bottomOverlayVC.closeController()
                }
            }
        }
        
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
    
    private func showDatePicker() {
        if bottomOverlayVC.presentingViewController == nil {
            present(bottomOverlayVC, animated: true, completion: nil)
        }
    
        func pickerHeight() -> CGFloat {
            if UIApplication.isDeviceWithSafeArea {
                return UIScreen.isSmallDevice ? 240 : 270
            } else {
                return UIScreen.isSmallDevice ? 215 : 230
            }
        }
        
        datePickerView.selectedSort = viewModel.selectedSortCategory.value.sortType
        
        bottomOverlayVC.showContentView(datePickerView)
        bottomOverlayVC.changeContentHeight(pickerHeight())
    }
    
    private func showCalendarPicker(selectedDates: Calendar.StartEndDate?) {
        if bottomOverlayVC.presentingViewController == nil {
            present(bottomOverlayVC, animated: true, completion: nil)
        }
        
        func pickerHeight() -> CGFloat {
            if UIApplication.isDeviceWithSafeArea {
                return UIScreen.isSmallDevice ? 370 : 400
            } else {
                return UIScreen.isSmallDevice ? 350 : 380
            }
        }
        
        bottomOverlayVC.showContentView(calendarPickerView)
        bottomOverlayVC.changeContentHeight(pickerHeight())
        calendarPickerView.selectedDates = selectedDates
    }
}
