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
typealias TypeClosure<T> = (T) -> ()
typealias CategoryViewModelClosure = (CategoryViewModel) -> ()

enum Currency {
    case uah
    case usd
    case rub
    case pln
    case eur
    case jpy
    case gbp
    case aud
    case cad
    case chf
    case cny
    case sek
    case nzd
    case egp
    
    // MARK: - Static
    static let all: [Currency] = [.uah, .usd, .eur, .pln,
                                  .rub, .jpy, .gbp, .aud,
                                  .cad, .chf, .cny, .sek,
                                  .nzd, .egp]
    
    // MARK: - Initializers
    init(stringValue: String) {
        switch stringValue {
        case Currency.uah.stringValue: self = .uah
        case Currency.usd.stringValue: self = .usd
        case Currency.rub.stringValue: self = .rub
        case Currency.pln.stringValue: self = .pln
        case Currency.eur.stringValue: self = .eur
        case Currency.jpy.stringValue: self = .jpy
        case Currency.gbp.stringValue: self = .gbp
        case Currency.aud.stringValue: self = .aud
        case Currency.cad.stringValue: self = .cad
        case Currency.chf.stringValue: self = .chf
        case Currency.cny.stringValue: self = .cny
        case Currency.sek.stringValue: self = .sek
        case Currency.nzd.stringValue: self = .nzd
        case Currency.egp.stringValue: self = .egp
        default: self = .usd
        }
    }
    
    // MARK: - Variables
    var stringValue: String {
        switch self {
        case .uah: return "uah"
        case .usd: return "usd"
        case .rub: return "rub"
        case .pln: return "pln"
        case .eur: return "eur"
        case .jpy: return "jpy"
        case .gbp: return "gbp"
        case .aud: return "aud"
        case .cad: return "cad"
        case .chf: return "chf"
        case .cny: return "cny"
        case .sek: return "sek"
        case .nzd: return "nzd"
        case .egp: return "egp"
        }
    }
    
    var symbol: String {
        switch self {
        case .uah: return "₴"
        case .usd: return "$"
        case .rub: return "₽"
        case .pln: return "zł"
        case .eur: return "€"
        case .jpy: return "¥"
        case .gbp: return "£"
        case .aud: return "$"
        case .cad: return "$"
        case .chf: return "₣"
        case .cny: return "¥"
        case .sek: return "kr"
        case .nzd: return "$"
        case .egp: return "E£"
        }
    }
    
    var flagName: String {
        return "ic_flag_" + stringValue
    }
}

extension Currency: Rawable {
    
    init(rawValue: Int) {
        switch rawValue {
        case 0: self = .uah
        case 1: self = .usd
        case 2: self = .rub
        case 3: self = .pln
        case 4: self = .eur
        case 5: self = .jpy
        case 6: self = .gbp
        case 7: self = .aud
        case 8: self = .cad
        case 9: self = .chf
        case 10: self = .cny
        case 11: self = .sek
        case 12: self = .nzd
        case 13: self = .egp
        default: self = .usd
        }
    }
    
    var rawValue: Int {
        switch self {
        case .uah: return 0
        case .usd: return 1
        case .rub: return 2
        case .pln: return 3
        case .eur: return 4
        case .jpy: return 5
        case .gbp: return 6
        case .aud: return 7
        case .cad: return 8
        case .chf: return 9
        case .cny: return 10
        case .sek: return 11
        case .nzd: return 12
        case .egp: return 13
        }
    }
    
}

enum SortEntity: StringRepresentable, Equatable {

    case total
    case wallet(entity: Entity)
    
    var stringValue: String {
        switch self {
        case .total: return "total"
        case .wallet(entity: let entity): return entity.title
        }
    }
    
    static func == (lhs: SortEntity, rhs: SortEntity) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}

enum Sort: StringRepresentable, Equatable {
    
    case day
    case week
    case month
    case year
    case custom(from: Date, to: Date)
    
    static var allValues: [Sort] {
        return [Sort.day, Sort.week, Sort.month,
                Sort.year, Sort.custom(from: Date(), to: Date())]
    }
    
    static var allCases: [String] {
        return Sort.allValues.map { $0.stringValue }
    }
    
    // MARK: - Variables
    
    var stringValue: String {
        switch self {
        case .day: return "Day".localized
        case .week: return "Week".localized
        case .month: return "Month".localized
        case .year: return "Year".localized
        case .custom(from: _, to: _): return "Custom".localized
        }
    }
    
    var startEndDate: Calendar.StartEndDate {
        switch self {
        case .day: return Calendar.current.currentDay()
        case .week: return Calendar.current.currentWeek()
        case .month: return Calendar.current.currentMonth()
        case .year: return Calendar.current.currentYear()
        case .custom(from: let fromDate, to: let toDate): return (fromDate, toDate)
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
