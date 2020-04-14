//
//  String+MoneyControl.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 15.03.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

extension String {
    
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var nullable: String? {
        isEmpty ? nil : self
    }
    
    var removingContinuousWhitespaces: String {
        components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.trimmed.nullable != nil }
            .joined(separator: " ")
    }
    
    func initials(maxInitialsCount: Int = 2) -> String {

        let allWords: [String] = self
            .removingContinuousWhitespaces
            .components(separatedBy: " ")

        guard allWords.count > 1 else { return prefix(maxInitialsCount).uppercased() }

        var retVal: String = ""

        for index in 0 ..< maxInitialsCount {
            guard index < allWords.count else { break }
            guard let firstCharacter = allWords[index].first else { break }

            retVal.append(firstCharacter)
        }

        return retVal.uppercased()
    }
    
    var coverImage: UIImage? {

        let dimension = UIScreen.main.bounds.width
        let fontSize = round(dimension * 0.36)

        let coverSize = CGSize(width: dimension, height: dimension)

        UIGraphicsBeginImageContextWithOptions(coverSize, false, 0)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let font = UIFont.systemRoundedFont(ofSize: fontSize, weight: .bold)

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.primaryText
        ]

        //

        let canvasRect = CGRect(origin: .zero, size: coverSize)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.walletPlaceholderBackground.cgColor)
        context?.fill(canvasRect)

        //

        let rect = CGRect(origin: CGPoint(x: 0, y: (coverSize.height - font.pointSize) / 2 - 8),
                          size: coverSize)

        (self as NSString).draw(in: rect, withAttributes: textAttributes)

        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - Texts
    
    func size(constrainedToWidth: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let constraintRect = CGSize(width: constrainedToWidth, height: .greatestFiniteMagnitude)
        return self.boundingRect(with: constraintRect,
                                 options: [.usesLineFragmentOrigin], attributes: attributes, context: nil).size
    }
    
    func size(constrainedToHeight: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: constrainedToHeight)
        return self.boundingRect(with: constraintRect,
                                 options: [.usesLineFragmentOrigin], attributes: attributes, context: nil).size
    }
    
}
