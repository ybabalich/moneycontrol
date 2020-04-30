//
//  Alert.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 30.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

typealias AlertClosure = (_ index: Int) -> Void
typealias AlertActionClosure = (AlertAction) -> Void

struct AlertAction: Equatable {
    let title: String?
    let style: UIAlertAction.Style
    
    init(title: String?, style: UIAlertAction.Style) {
        self.title = title
        self.style = style
    }
    
    init(from action: UIAlertAction) {
        title = action.title
        style = action.style
    }
    
    // MARK: - Equatable
    static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        return lhs.title == rhs.title && lhs.style == rhs.style
    }
}

class Alert: NSObject {
    
    // MARK: - Variables
    var alertController: UIAlertController?
    
    // MARK: - Class methods
    @discardableResult
    class func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> Alert {
        let alert = Alert()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.alertController = alertController
        return alert
    }
    
    @discardableResult
    class func showNoYes(title: String?, message: String?, show controller: UIViewController!, completion: AlertClosure?) -> Alert {
        let alert = Alert.alert(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion?(1)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            completion?(0)
        }
        
        alert.alertController?.addAction(yesAction)
        alert.alertController?.addAction(noAction)
        alert.show(in: controller)
        return alert
    }
    
    @discardableResult
    class func showOk(title: String?, message: String?, show controller: UIViewController?, completion: AlertClosure?) -> Alert {
        let alert = Alert.alert(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            completion?(0)
        }
        
        alert.alertController?.addAction(okAction)
        alert.show(in: controller)
        return alert
    }
    
    @discardableResult
    class func show(title: String?,
                    message: String?,
                    actions: [AlertAction],
                    in controller: UIViewController?,
                    completion: AlertActionClosure?) -> Alert {
        let alert = Alert.alert(title: title, message: message, preferredStyle: .alert)
        actions.forEach { action in
            alert.add(action: action, completion: completion)
        }
        alert.show(in: controller)
        return alert
    }
    
    // MARK: - Public methods
    func add(action: AlertAction, completion: AlertActionClosure?) {
        guard let alertController = alertController else { return }
        
        let uiAlertAction = UIAlertAction(title: action.title, style: action.style, handler: { action in
            completion?(AlertAction(from: action))
        })
        alertController.addAction(uiAlertAction)
    }
    
    func show(in controller: UIViewController?) {
        guard let alertController = alertController else { return }
        
        func showFrom(controller: UIViewController) {
            controller.present(alertController, animated: true, completion: nil)
        }
        
        if let controller = controller {
            showFrom(controller: controller)
        } else {
            if let topController = UIViewController.topController {
                showFrom(controller: topController)
            }
        }
    }
    
    func show(from navigation: UINavigationController) {
        guard let alertController = alertController else { return }
        
        navigation.present(alertController, animated: true, completion: nil)
    }
}
