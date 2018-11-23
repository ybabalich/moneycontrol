//
//  Money.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import Foundation

enum Currency {
    case uah
    case usd
    case rub
}

enum MoneyType {
    case incoming
    case outcoming
}

enum Entity {
    case cash
    case card(name: String)
    
    // MARK: - Variables
    var value: String {
        switch self {
        case .cash: return CashDefaultName
        case .card(name: let cardName): return CardDefaultBaseNamePrefix + cardName
        }
    }
}

protocol Money {
    var value: Double { get set }
    var currency: Currency { get set }
    var type: MoneyType { get set }
    var category: Category { get set }
    var entity: Entity { get set }
}

struct Circulation: Money {
    
    // MARK: - Variables
    var value: Double
    var currency: Currency
    var type: MoneyType
    var category: Category
    var entity: Entity
}
