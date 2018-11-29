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
        let currentDate = Date()
        let weekDayComponents = dateComponents([.weekday], from: currentDate)
        
        var components = DateComponents()
        // Sunday -> -(weekdayComponetns.weekday - firstWeekday)
        // Monday -> -(weekdayComponetns.weekday - firstWeekday - 1)
        components.day = -(weekDayComponents.weekday! - firstWeekday - 1)
        
        //start of week
        var beginningOfWeek = date(byAdding: components, to: currentDate)
        
        let componentsForBeginningOfWeek = dateComponents([.year, .month, .day], from: beginningOfWeek!)
        beginningOfWeek = date(from: componentsForBeginningOfWeek)
        
        //end of week
        components.day = 7
        
        var endOfWeek = date(byAdding: components, to: beginningOfWeek!)
        
        let componentsForEndOfWeek = dateComponents([.year, .month, .day], from: endOfWeek!)
        endOfWeek = date(from: componentsForEndOfWeek)
        
        
        return (beginningOfWeek!, endOfWeek!)
    }
    
}
