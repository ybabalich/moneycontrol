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


// MARK: - Protocol's
protocol Rawable {
    associatedtype `Type`
    
    init(rawValue: Type)
    var rawValue: Type { get }
}

protocol StringRepresentable {
    var stringValue: String { get }
}
