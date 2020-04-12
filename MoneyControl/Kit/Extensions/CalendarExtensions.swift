//
//  CalendarExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

extension Calendar {
    
    public typealias StartEndDate = (start: Date, end: Date)
    
    // MARK: - Public methods
    
    /*
     * Return start and end date of current day
     */
    func currentDay() -> StartEndDate {
        let currentDay = getStartEndDateFrom(.day)
        print("Start ->: \(currentDay.start.description(with: .current))")
        print("End ->: \(currentDay.end.description(with: .current))")
        print("-----")
        return getStartEndDateFrom(.day)
    }
    
    /*
     * Return start and end date of current week
     */
    func currentWeek() -> StartEndDate {
        let currentWeek = getStartEndDateFrom(.weekOfYear)
        print("Start ->: \(currentWeek.start.description(with: .current))")
        print("End ->: \(currentWeek.end.description(with: .current))")
        print("-----")
        return currentWeek
    }
    
    /*
     * Return start and end date of current month
     */
    func currentMonth() -> StartEndDate {
        let currentMonth = getStartEndDateFrom(.month)
        print("Start ->: \(currentMonth.start.description(with: .current))")
        print("End ->: \(currentMonth.end.description(with: .current))")
        print("-----")
        return currentMonth
    }
    
    /*
     * Return start and end date of current month
     */
    func currentYear() -> StartEndDate {
        let currentYear = getStartEndDateFrom(.year)
        print("Start ->: \(currentYear.start.description(with: .current))")
        print("End ->: \(currentYear.end.description(with: .current))")
        print("-----")
        return currentYear
    }
    
    // MARK: - Private methods
    private func getStartEndDateFrom(_ component: Component) -> StartEndDate {
        var startDate = Date()
        var endDate = Date()
        var interval: TimeInterval = 0
        
        //start date
        let _ = dateInterval(of: component, start: &startDate, interval: &interval, for: startDate)
        
        //end date
        var components = DateComponents()
        
        switch component {
        case .month:
            components.month = 1
        case .weekOfYear:
            components.weekOfYear = 1
        case .year:
            components.year = 1
        default:
            components.day = 1
        }
        
        components.second = -1
        
        endDate = date(byAdding: components, to: startDate)!
        
        let componentsForEndOfWeek = dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
        endDate = date(from: componentsForEndOfWeek)!
        
        return (startDate, endDate)
    }
    
}
