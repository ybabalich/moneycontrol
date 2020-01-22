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
