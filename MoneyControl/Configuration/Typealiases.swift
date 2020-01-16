//
//  Typealiases.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 11/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

// MARK: - Typealias
typealias EmptyClosure = () -> ()
typealias CategoryViewModelClosure = (CategoryViewModel) -> ()

enum Currency {
    case uah
    case usd
    case rub
    
    // MARK: - Initializers
    init(stringValue: String) {
        switch stringValue {
        case Currency.uah.stringValue: self = .uah
        case Currency.usd.stringValue: self = .usd
        case Currency.rub.stringValue: self = .rub
        default: self = .usd
        }
    }
    
    // MARK: - Variables
    var stringValue: String {
        switch self {
        case .uah: return "uah"
        case .usd: return "usd"
        case .rub: return "rub"
        }
    }
    
    var symbol: String {
        switch self {
        case .uah: return "₴"
        case .usd: return "$"
        case .rub: return "₽"
        }
    }
    
    var flagName: String {
        return "ic_flag_" + stringValue
    }
}

enum Sort: StringRepresentable, Equatable {
    case day
    case week
    case month
    case year
    case custom(from: Date, to: Date)
    
    // MARK: - Variables
    var stringValue: String {
        switch self {
        case .day: return "Day".localized
        case .week: return "Week".localized
        case .month: return "Month".localized
        case .year: return "Year"
        case .custom(from: _, to: _): return "Custom"
        }
    }
}


// MARK: - Protocol's
protocol Rawable {
    associatedtype `Type`
    
    init(rawValue: Type)
    var rawValue: Type { get }
}

protocol StringRepresentable {
    var stringValue: String { get }
}
