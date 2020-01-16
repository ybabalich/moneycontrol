//
//  CalendarViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/13/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import JTAppleCalendar

class CalendarViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var calendarViewContent: UIView!
    
    // MARK: - Variables private
    private var calendarView = JTAppleCalendarView()
    private var selectedFirstDate: Date?
    private var selectedSecondDate: Date?
    
    // MARK: - Class methods
    class func controller() -> CalendarViewController {
        let controller: CalendarViewController = CalendarViewController.nib()
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        calendarView = JTAppleCalendarView()
        calendarView.backgroundColor = .clear
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        calendarView.registerNib(type: CalendarCollectionViewCell.self)
        calendarViewContent.addSubview(calendarView)
        calendarView.alignExpandToSuperview()
    }

}
//
extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCollectionViewCell",
                                                       for: indexPath) as! CalendarCollectionViewCell
        
        cell.dayLabel.text = cellState.text
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.dayLabel.textColor = .black
        } else {
            cell.dayLabel.textColor = .gray
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if selectedFirstDate != nil {
            calendarView.selectDates(from: selectedFirstDate!,
                                     to: date,
                                     triggerSelectionDelegate: true,
                                     keepSelectionIfMultiSelectionAllowed: true)
        } else {
            selectedFirstDate = date
        }
        
        (cell as? CalendarCollectionViewCell)?.isActive = true
        switch cellState.selectedPosition {
        default:
            (cell as? CalendarCollectionViewCell)?.isActive = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        (cell as? CalendarCollectionViewCell)?.isActive = cellState.isSelected
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2018 10 13")! // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .monday)
        return parameters
    }
    
    
}
