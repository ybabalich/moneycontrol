//
//  CalendarExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/29/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

extension Calendar {
    
    typealias StartEndDate = (start: Date, end: Date)
    
    // MARK: - Public methods
    
    /*
     * Return start and end date of current day
     */
    func currentDay() -> StartEndDate {
        let currentDate = Date()
        let dateFrom = startOfDay(for: currentDate)
        let dateTo = date(byAdding: .day, value: 1, to: dateFrom)!
        return (dateFrom, dateTo)
    }
    
    /*
     * Return start and end date of current week
     */
    func currentWeek() -> StartEndDate {
        return getStartEndDateFrom(.weekOfYear)
    }
    
    /*
     * Return start and end date of current month
     */
    func currentMonth() -> StartEndDate {
        return getStartEndDateFrom(.month)
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
            components.second = -1
        case .weekOfYear:
            components.weekOfYear = 1
            components.second = -1
        default:
            components.month = 1
            components.day = 1
        }
        
        endDate = date(byAdding: components, to: startDate)!
        
        let componentsForEndOfWeek = dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
        endDate = date(from: componentsForEndOfWeek)!
        
        return (startDate, endDate)
    }
    
}
