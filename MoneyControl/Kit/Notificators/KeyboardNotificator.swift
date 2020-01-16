//
//  KeyboardNotificator.swift
//  TranslationApp
//
//  Created by Yaroslav Babalich on 3/1/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import UIKit

enum KeyboardNotificatorEventType {
    case willHide
    case willShow
    case didShow
    case didHide
}

typealias KeyboardNotificatorEventClosure = (_ eventType: KeyboardNotificatorEventType, _ keyboardFrame: CGRect) -> ()

protocol KeyboardNotificatorDelegate {
    func keyboardNotifier(eventType: KeyboardNotificatorEventType, _ keyboardFrame: CGRect)
}

class KeyboardNotificator: NSObject {
    
    // MARK: - Variables
    var delegate: KeyboardNotificatorDelegate?
    
    // MARK: - Initialization methods
    override init () {
        super.init()
        self.keyboardNotifications(start: true)
    }
    
    deinit {
        self.keyboardNotifications(start: false)
    }
    
    // MARK: - Variables
    public var onEventClosure: KeyboardNotificatorEventClosure?
    
    // MARK: - Public methods
    public func onEvent(completion: @escaping KeyboardNotificatorEventClosure) {
        self.onEventClosure = completion
    }
    
    // MARK: - Private methods
    private func keyboardNotifications(start: Bool) {
        if (start) {
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardNotificator.keyboardWillShow(notification:)),
                                                   name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardNotificator.keyboardWillHide(notification:)),
                                                   name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardNotificator.keyboardDidShow(notification:)),
                                                   name: UIResponder.keyboardDidShowNotification , object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardNotificator.keyboardDidHide(notification:)),
                                                   name: UIResponder.keyboardDidHideNotification , object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardNotificator.keyboardWillShow(notification:)),
                                                   name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardNotificator.keyboardDidShow(notification:)),
                                                   name: UIResponder.keyboardDidChangeFrameNotification , object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
    }
    
    // MARK: - NotificationCenter(Keyboard)
    @objc private func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        onEventClosure?(.willShow, keyboardFrame)
        delegate?.keyboardNotifier(eventType: .willShow, keyboardFrame)
    }
    
    @objc private func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        onEventClosure?(.didShow, keyboardFrame)
        delegate?.keyboardNotifier(eventType: .didShow, keyboardFrame)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        onEventClosure?(.willHide, keyboardFrame)
        delegate?.keyboardNotifier(eventType: .willHide, keyboardFrame)
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        onEventClosure?(.didHide, keyboardFrame)
        delegate?.keyboardNotifier(eventType: .didHide, keyboardFrame)
    }
}

