//
//  Date+MoneyControl.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import Foundation

extension Date {
    
    var shortString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        return dateFormatter.string(from: self)
    }

    var startOfDay: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func isDMYEqualTo(date: Date) -> Bool {
        let compareCompoments = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let selfComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        
        return compareCompoments.day == selfComponents.day
            && compareCompoments.month == selfComponents.month
            && compareCompoments.year == selfComponents.year
    }
    
    func createDMY() -> Date? {
        let selfComponents = Calendar.current.dateComponents([.day, .month, .year, .weekday], from: self)
        return Calendar.current.date(from: DateComponents(year: selfComponents.year,
                                                          month: selfComponents.month,
                                                          day: selfComponents.day))
    }
    
    func dayNumber() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func dayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func monthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        return dateFormatter.string(from: self)
    }
    
}
