//
//  PasscodeCoordinator.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit
import Then

class PasscodeCoordinator: Coordinator {

    //
    // MARK: - Public Accessors

    var whenConfirmed: EmptyClosure?
    var whenCancelled: EmptyClosure?

    class var defaultState: PasscodeLockViewController.LockState { .verify }

    //
    // MARK: - Private Stuff

    private let window: UIWindow

    private var configuration: PasscodeLockConfigurationType!
    private(set) var viewController: PasscodeLockViewController!

    private var passcodeLength: Int = -1

    //
    // MARK: - Window Lifecycle

    init(window: UIWindow) {
        self.window = window

        super.init()
    }

    //
    // MARK: - Appearance Management

    func start(length: Int) {

        guard passcodeLength != length else {
            start()
            return
        }

        configuration = PasscodeLockConfiguration(
            passcodeLength: length,
            maximumInccorectPasscodeAttempts: Money.instance.settings.passcodeMaximumFailAttempts
        )

        viewController = PasscodeLockViewController(state: Self.defaultState, configuration: configuration).with { vc in

//            vc.view.backgroundColor = .clear

            vc.successCallback = whenConfirmed
            vc.cancelCallback = whenCancelled
        }

        window.rootViewController = viewController

        passcodeLength = length
        start()
    }

    override func start() {

        viewController.resetInputs()

        guard !isPresented else { return }
        super.start()

        guard configuration.repository.hasPasscode else { return }

        let userCallback = viewController.dismissCompletionCallback

        viewController.dismissCompletionCallback = { [weak self] in
            userCallback?()
            self?.finish()
        }

        //

        window.rootViewController?.view.alpha = 0
        window.makeKeyAndVisible()

//        viewController.viewWillAppear(true)

        UIView.animate(
            withDuration: 0.2, delay: 0,
            options: [.beginFromCurrentState],
            animations: { self.window.rootViewController?.view.alpha = 1 },
            completion: { _ in self.viewController.viewDidAppear(true) }
        )
    }

    override func finish() {

        guard isPresented else { return }
        super.finish()

        viewController.viewWillDisappear(true)

        UIView.animate(
            withDuration: 0.2, delay: 0,
            options: [],
            animations: { self.window.rootViewController?.view.alpha = 0 },
            completion: { _ in
                if !self.isPresented {
                    self.window.isHidden = true
                    self.viewController.viewDidDisappear(true)
                }
            }
        )
    }
}

