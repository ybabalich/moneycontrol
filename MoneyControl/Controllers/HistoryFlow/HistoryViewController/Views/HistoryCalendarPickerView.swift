//
//  HistoryCalendarPickerView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit
import FSCalendar

class HistoryCalendarPickerView: UIView {

    // MARK: - UI
    
    private var backButton: TappableButton!
    private var closeButton: TappableButton!
    private var calendar: FSCalendar!
    private var okButton: TappableButton!

    // MARK: - Variables private
    
    private var firstSelectedDate: Date?
    private var lastSelectedDate: Date?
    private var datesRange: [Date] = [] {
        didSet {
            updateUI()
        }
    }
    
    private var _backClosure: EmptyClosure?
    private var _closeClosure: EmptyClosure?
    private var _chooseClosure: TypeClosure<Sort>?
    
    // MARK: - Variables public
    
    var selectedDates: Calendar.StartEndDate? {
        didSet {
            if let selectedDates = selectedDates {
                firstSelectedDate = selectedDates.start
                lastSelectedDate = selectedDates.end
                selectDates(from: selectedDates.start, to: selectedDates.end)
            } else {
                calendar.selectedDates.forEach { date in
                    calendar.deselect(date)
                }
                
                firstSelectedDate = nil
                lastSelectedDate = nil
                datesRange = []
            }
        }
    }
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("HistoryCalendarPickerView")
    }
    
    // MARK: - Public methods
    
    func onBackTap(completion: @escaping EmptyClosure) {
        _backClosure = completion
    }
    
    func onCloseTap(completion: @escaping EmptyClosure) {
        _closeClosure = completion
    }
    
    func onChoose(completion: @escaping TypeClosure<Sort>) {
        _chooseClosure = completion
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        backgroundColor = .mainBackground
        
        closeButton = TappableButton(type: .custom).then { closeButton in
            
            closeButton.setImage(UIImage(named: "ic_close"), for: .normal)
            closeButton.tintColor = .controlTintDestructive
            closeButton.onTap { [unowned self] in
                self._closeClosure?()
            }
            
            addSubview(closeButton)
            closeButton.snp.makeConstraints {
                $0.height.width.equalTo(25)
                $0.right.top.equalToSuperview().inset(8)
            }
        }
        
        backButton = TappableButton(type: .custom).then { backButton in
            
            backButton.setImage(UIImage(named: "ic_back"), for: .normal)
            backButton.tintColor = .primaryText
            backButton.onTap { [unowned self] in
                self._backClosure?()
            }
            
            addSubview(backButton)
            backButton.snp.makeConstraints {
                $0.width.equalTo(20)
                $0.height.equalTo(17)
                $0.centerY.equalTo(closeButton.snp.centerY)
                $0.left.equalToSuperview().offset(12)
            }
        }
        
        calendar = FSCalendar().then { calendar in
            
            calendar.appearance.titleFont = App.Font.main(size: 14, type: .bold).rawValue
            calendar.appearance.headerTitleFont = App.Font.main(size: 17, type: .bold).rawValue
            calendar.appearance.headerTitleColor = .primaryText
            calendar.appearance.titleWeekendColor = .controlTintDestructive
            calendar.appearance.titleDefaultColor = .controlTintActive
            calendar.appearance.todayColor = .controlTintDestructive
            calendar.appearance.selectionColor = .controlTintActive
            calendar.appearance.weekdayTextColor = .primaryText
            calendar.backgroundColor = .mainBackground
            calendar.allowsMultipleSelection = true
            calendar.delegate = self
            
            addSubview(calendar)
            calendar.snp.makeConstraints {
                $0.top.equalTo(closeButton.snp.bottom).offset(8)
                $0.left.right.equalToSuperview().inset(8)
            }
        }
        
        okButton = TappableButton(type: .custom).then { okButton in
            
            okButton.setTitle("Choose".localized.uppercased(), for: .normal)
            okButton.titleLabel?.font = App.Font.main(size: 15, type: .bold).rawValue
            okButton.backgroundColor = UIColor.controlTintGreen.withAlphaComponent(0.8)
            okButton.onTap { [unowned self] in
                self.performFinishClosure()
            }
            
            addSubview(okButton)
            okButton.snp.makeConstraints {
                $0.top.equalTo(calendar.snp.bottom).offset(8)
                $0.left.bottom.right.equalToSuperview()
                $0.height.equalTo(45)
            }
        }
        
        updateUI()
    }
    
    private func updateUI() {
        if datesRange.isEmpty {
            okButton.isEnabled = false
            okButton.backgroundColor = UIColor.controlTintGreen.withAlphaComponent(0.2)
        } else {
            okButton.isEnabled = true
            okButton.backgroundColor = UIColor.controlTintGreen.withAlphaComponent(0.8)
        }
    }
    
    private func performFinishClosure() {
        guard !datesRange.isEmpty else { return }
        
        if datesRange.count > 1, let firstDate = datesRange.first, let secondDate = datesRange.last {
            _chooseClosure?(Sort.custom(from: firstDate, to: secondDate))
        } else {
            if let firstDate = datesRange.first {
                _chooseClosure?(Sort.custom(from: firstDate, to: firstDate))
            }
        }
    }
    
    private func selectDates(from: Date, to: Date) {
        let dates = Date.dates(from: from, to: to)
        
        for d in dates {
            calendar.select(d)
        }
    }
    
}

extension HistoryCalendarPickerView: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        if firstSelectedDate == nil { // nothing selected
            firstSelectedDate = date
            datesRange = [firstSelectedDate!]
            
            return
        }

        if firstSelectedDate != nil && lastSelectedDate == nil { // selected just first value
            
            if date <= firstSelectedDate! { // if first selected date less then second selected
                calendar.deselect(firstSelectedDate!)
                firstSelectedDate = date
                datesRange = [firstSelectedDate!]
                
                return
            }

            lastSelectedDate = date
            
            datesRange = Date.dates(from: firstSelectedDate!, to: lastSelectedDate!)
            
            for d in datesRange {
                calendar.select(d)
            }
            
            return
        }

        if firstSelectedDate != nil && lastSelectedDate != nil { // if both dates selected
            
            if date < firstSelectedDate! {
                datesRange.forEach { date in
                    calendar.deselect(date)
                }
                
                lastSelectedDate = nil
                firstSelectedDate = date

                datesRange = [firstSelectedDate!]
            } else if date > firstSelectedDate! && date < lastSelectedDate! {
                
                
                
            } else if date > lastSelectedDate! { // if selected date bigger then last selected date
                
                datesRange = Date.dates(from: firstSelectedDate!, to: date)
                
                Date.dates(from: lastSelectedDate!, to: date).forEach { date in
                    calendar.select(date)
                }
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        // NOTE: the is a REDUANDENT CODE:
        if firstSelectedDate != nil && lastSelectedDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastSelectedDate = nil
            firstSelectedDate = nil

            datesRange = []
        }
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
