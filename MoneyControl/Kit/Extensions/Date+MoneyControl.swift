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
        var startDate = Date()
        var interval: TimeInterval = 0
        
        //start date
        let _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &interval, for: startDate)
        return startDate
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
}
