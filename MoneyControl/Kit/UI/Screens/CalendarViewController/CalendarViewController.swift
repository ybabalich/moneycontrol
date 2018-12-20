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
    @IBOutlet weak var calendarView: UIView!
    
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
        let calendarViewC = JTAppleCalendarView()
        calendarViewC.backgroundColor = .clear
        calendarViewC.calendarDataSource = self
        calendarViewC.calendarDelegate = self
        calendarViewC.registerNib(type: CalendarCollectionViewCell.self)
        calendarView.addSubview(calendarViewC)
        calendarViewC.alignExpandToSuperview()
//        calendarView.calendarDataSource = self
        
        
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
        
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2018 12 13")! // You can use date generated from a formatter
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
