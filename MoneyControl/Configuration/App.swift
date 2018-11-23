//
//  Defines.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 9/23/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import UIKit

struct App {
    
    static let MainFontName = "Lato"
    
    enum Font {
        enum FontType {
            case regular
            case bold
            case light
        }
        
        case main(size: CGFloat, type: FontType)
    }
    
    enum Color {
        case main
        case checkBtnIncoming
        case checkBtnOutcoming
    }
    
}

extension App.Color: Rawable {
    
    // MARK: - Variables
    var rawValue: UIColor {
        switch self {
        case .main: return UIColor(hex: 0x212121)
        case .checkBtnIncoming: return UIColor(hex: 0xd63031)
        case .checkBtnOutcoming: return UIColor(hex: 0x00b894)
        }
    }
    
    // MARK: - Initializers
    init(rawValue: UIColor) {
        self = .main
    }
    
}

extension App.Font: Rawable {
    
    // MARK: - Initalize methods
    init(rawValue: UIFont) {
        self = .main(size: 0, type: .regular)
    }
    
    // MARK: - Variables
    var rawValue: UIFont {
        switch self {
        case .main(size: let size, type: let type): return UIFont(name: fontName(by: type), size: size)!
        }
    }
    
    // MARK: - Private methods
    private func fontName(by: FontType) -> String {
        return App.MainFontName + "-" + by.rawValue.capitalized
    }
}

extension App.Font.FontType: Rawable {
    
    // MARK: - Initalize methods
    init(rawValue: String) {
        self = .regular
    }
    
    // MARK: - Variables
    var rawValue: String {
        switch self {
        case .regular: return "regular"
        case .bold: return "bold"
        case .light: return "light"
        }
    }
    
}
