//
//  LimitedTextField.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 17.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class LimitedTextField: UITextField {
    
    enum TextFieldEnterType {
        case none
        case charactersLimit(range: ClosedRange<Int>, isNumeric: Bool)
        case numberLimit(range: ClosedRange<Double>)
        case numbers(symbolsAfterDot: Int)
        case formatted(replacementCharacter: Character, format: NSString) //for example: replacementChar -> *, format -> **/** | 21/2021
        case percentage(range: ClosedRange<Double>)
    }
    
    // MARK: - Variables public
    var enterType: TextFieldEnterType = .charactersLimit(range: 2...64, isNumeric: false) {
        didSet {
            switch enterType {
            case .numberLimit(range: _):
                keyboardType = .numberPad
            case .numbers(symbolsAfterDot: _):
                keyboardType = .decimalPad
            default: return
            }
        }
    }
    var initialText: String? {
        didSet {
            text = initialText
            sendActions(for: .editingChanged)
        }
    }
    var percentage: Double {
        set {
            if newValue > 0.0 {
                _percentageString = String(Int(newValue * 100))
                replaceToPercentageMask()
            } else {
                text = "0.0%"
            }
        }
        get {
            let percentFormatter = NumberFormatter()
            percentFormatter.numberStyle = .decimal
            percentFormatter.minimumFractionDigits = 1
            percentFormatter.maximumFractionDigits = 2
            
            return (percentFormatter.number(from: _percentageString)?.doubleValue ?? 0.0) / 100
        }
    }
    
    // MARK: - Variables private
    private var _percentageString = ""
    private var _onDidBeginEditingClosure: EmptyClosure?
    private var _onChangedClosure: TypeClosure<String>?
    private var _onDidEndEditingClosure: EmptyClosure?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        notification(subscribe: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        notification(subscribe: true)
    }
    
    deinit {
        notification(subscribe: false)
    }
    
    // MARK: - Public methods
    func onDidBeginEditing(completion: @escaping EmptyClosure) {
        _onDidBeginEditingClosure = completion
    }
    
    func onChanged(completion: @escaping TypeClosure<String>) {
        _onChangedClosure = completion
    }
    
    func onDidEndEditing(completion: @escaping EmptyClosure) {
        _onDidEndEditingClosure = completion
    }
    
    // MARK: - Private methods
    private func notification(subscribe: Bool) {
        if subscribe {
            delegate = self
            addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    private func makeOnlyDigitsString(string: String) -> String {
        return string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    private func replaceText(replacementCharacter: Character, format: NSString) {
        guard let text = text else { return }
        
        if text.count > 0 && format.length > 0 {
            let tempString: NSString = makeOnlyDigitsString(string: text) as NSString
            
            var finalText: NSString = ""
            var stop = false
            
            var formatterIndex = 0
            var tempIndex = 0
            
            while !stop {
                let formattingPatternRange = NSRange(location: formatterIndex, length: 1)
                
                if format.substring(with: formattingPatternRange) != String(replacementCharacter) {
                    finalText = finalText.appending(format.substring(with: formattingPatternRange)) as NSString
                } else if tempString.length > 0 {
                    let pureStringRange = NSRange(location: tempIndex, length: 1)
                    finalText = finalText.appending(tempString.substring(with: pureStringRange)) as NSString
                    tempIndex += 1
                }
                
                formatterIndex += 1
                
                if formatterIndex >= format.length || tempIndex >= tempString.length {
                    stop = true
                }
            }
            
            self.text = finalText as String
        }
    }

    func replaceToPercentageMask() {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        percentFormatter.multiplier = 1
        percentFormatter.minimumFractionDigits = 1
        percentFormatter.maximumFractionDigits = 2
        
        let numberFromField = NSString(string: _percentageString).doubleValue / 100
        let formattedText = percentFormatter.string(from: NSNumber(value: numberFromField))
        text = formattedText
        
        _onChangedClosure?(formattedText ?? "")
    }
    
    private func updateText() {
        switch enterType {
        case .formatted(replacementCharacter: let character, format: let format):
            replaceText(replacementCharacter: character, format: format)
        case .percentage(range: _):
            replaceToPercentageMask()
        default: return
        }
    }
    
    // MARK: - Events
    @objc private func textFieldDidChange() {
        updateText()
        _onChangedClosure?(text ?? "")
    }
}

extension LimitedTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        switch enterType {
        case .charactersLimit(range: let charactersLimit, isNumeric: let isNumeric):
            let nsStringText = text as NSString
            let newString = nsStringText.replacingCharacters(in: range, with: string)
            
            if isNumeric {
                if string.isEmpty {
                    return newString.count <= charactersLimit.upperBound
                } else {
                    return newString.count <= charactersLimit.upperBound && makeOnlyDigitsString(string: string).count > 0
                }
            } else {
                return newString.count <= charactersLimit.upperBound
            }
        case .numberLimit(range: let numberLimit):
            let nsStringText = text as NSString
            var newString = nsStringText.replacingCharacters(in: range, with: string)
            
            if newString.isEmpty {
                newString = "0"
            }
            
            if let number = Double(makeOnlyDigitsString(string: newString)) {
                return numberLimit.contains(number)
            } else {
                return false
            }
        case .numbers(symbolsAfterDot: let symbolsLimit):
            let nsStringText = text as NSString
            let newString = nsStringText.replacingCharacters(in: range, with: string)
            
            if !string.isEmpty && string.isDouble {
                let strings = newString.components(separatedBy: [",", "."])
                
                if strings.count == 2 {
                    if strings[1].count <= symbolsLimit {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            } else { return true }
        case .percentage(range: let percentageLimit):
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                let temporaryValue = Double(makeOnlyDigitsString(string: _percentageString + string))! / 100
                
                if !percentageLimit.contains(temporaryValue) {
                    return false
                }
                    
                _percentageString += string
                replaceToPercentageMask()
            default:
                let array = Array(string)
                var currentStringArray = Array(_percentageString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    _percentageString = ""
                    for character in currentStringArray {
                        _percentageString += String(character)
                    }
                    replaceToPercentageMask()
                }
            }
            return false
        default: return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch enterType {
        case .charactersLimit(range: let charactersLimit, isNumeric: _):
            return textField.text?.count ?? 0 >= charactersLimit.lowerBound
        default: return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _onDidBeginEditingClosure?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _onDidEndEditingClosure?()
    }
}

