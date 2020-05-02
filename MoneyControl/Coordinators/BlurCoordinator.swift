//
//  BlurCoordinator.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 30.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class BlurCoordinator: Coordinator {

    //
    // MARK: - Private Stuff

    private let window: UIWindow
    private var shouldForce: Bool = false

    //
    // MARK: - IB Outlets

    private let effect = UIBlurEffect(style: .regular)

    private var blurredView: UIView!
    private var visualEffectView: UIVisualEffectView!

    //
    // MARK: - Object Lifecycle

    init(window: UIWindow) {

        self.window = window
        window.rootViewController = UIViewController()

        super.init()

        //
        // Blur Effect

        blurredView = UIView().then { v in
            window.addSubview(v)
            v.snp.makeConstraints { $0.edges.equalToSuperview() }
        }

        visualEffectView = UIVisualEffectView().then { v in
            v.effect = nil
            blurredView.addSubview(v)
            v.snp.makeConstraints { $0.edges.equalToSuperview() }
        }

        //

        subsribeToApplicationStateEvents()
    }

    //
    // MARK: - Appearance Management

    override func start() {
        self.start(forced: false)
    }

    override func finish() {
        self.finish(forced: false)
    }

    func start(forced: Bool, status: String? = nil) {

        if shouldForce == false { shouldForce = forced }

        guard !isPresented else { return }
        super.start()

        window.makeKeyAndVisible()

        UIView.animate(
            withDuration: 0.2, delay: 0,
            options: [.beginFromCurrentState],
            animations: {
                self.visualEffectView.effect = self.effect
            },
            completion: nil
        )
    }

    func finish(forced: Bool) {

        guard shouldForce == false || forced else { return }
        shouldForce = false

        guard isPresented else { return }
        super.finish()

        UIView.animate(
            withDuration: 0.2, delay: 0,
            options: [.beginFromCurrentState],
            animations: {
                self.visualEffectView.effect = nil
            },
            completion: { _ in if !self.isPresented { self.window.isHidden = true } }
        )
    }
}

private extension BlurCoordinator {

    func subsribeToApplicationStateEvents() {

        NotificationCenter.default.addObserver(
            self, selector: #selector(applicationWillResignActive(_:)),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(applicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc func applicationWillResignActive(_ notification: Notification) {
        start()
    }

    @objc func applicationDidBecomeActive(_ notification: Notification) {
        finish()
    }
}

