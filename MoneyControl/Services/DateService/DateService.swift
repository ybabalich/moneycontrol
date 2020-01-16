//
//  DateService.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/15/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import Foundation

class DateService {
    
    // MARK: - Singleton
    static let instance: DateService = DateService()
    
    // MARK: - Static Variables
    static let dayMonthYearWithSpacesFormat = "dd MMMM yyyy"
    
    // MARK: - Private variables
    private var dateFormatter = DateFormatter()
    
    // MARK: - Public methods
    func convertDateToString(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}
