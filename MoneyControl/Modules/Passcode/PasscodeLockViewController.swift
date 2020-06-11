//
//  PasscodeLockViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 03.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

public class PasscodeLockViewController: UIViewController, PasscodeLockTypeDelegate {
    
    public enum LockState {
        case verify
        case cancellableVerify
        case setNew
        
        func getState() -> PasscodeLockStateType {
            
            switch self {
            case .verify: return EnterPasscodeState()
            case .cancellableVerify: return EnterPasscodeState(allowCancellation: true)
            case .setNew: return SetPasscodeState()
            }
        }
    }
        
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var deleteSignButton: UIButton!
    @IBOutlet private weak var optionsButton: UIButton!

    @IBOutlet private weak var attemptsContainer: UIView!
    @IBOutlet private weak var attemptsLabel: UILabel!

    @IBOutlet private weak var placeholdersX: NSLayoutConstraint?
    @IBOutlet private var placeholders: [PasscodeSignPlaceholderView] = []
    
    var successCallback: EmptyClosure?
    var cancelCallback: EmptyClosure?
    var dismissCompletionCallback: EmptyClosure?

    public var animateOnDismiss: Bool
    public var notificationCenter: NotificationCenter?
    
    internal var passcodeConfiguration: PasscodeLockConfigurationType
    internal var passcodeLock: PasscodeLockType
    internal var isPlaceholdersAnimationCompleted = true
    
    private var shouldTryToAuthenticateWithBiometrics = true
    
    // MARK: - Initializers
    
    public init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
        
        self.animateOnDismiss = animateOnDismiss
        
        passcodeConfiguration = configuration
        passcodeLock = PasscodeLock(state: state, configuration: configuration)
        
        super.init(nibName: "PasscodeLockView", bundle: Bundle.main)
        
        passcodeLock.delegate = self
        notificationCenter = NotificationCenter.default
    }
    
    public convenience init(state: LockState, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
        
        self.init(state: state.getState(), configuration: configuration, animateOnDismiss: animateOnDismiss)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        
        updatePasscodeView()
        deleteSignButton?.isEnabled = false
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePasscodeView()
        resetInputs()
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal func updatePasscodeView() {

        attemptsContainer.layer.cornerRadius = attemptsContainer.bounds.height / 2
        attemptsContainer.layer.masksToBounds = true
        attemptsContainer.isHidden = true

        //titleImage.image = passcodeLock.state.titleImage
        titleLabel.text = passcodeLock.state.title
        descriptionLabel.text = passcodeLock.state.description
        
        cancelButton.isHidden = !passcodeLock.state.isCancellableAction
        optionsButton.isHidden = !passcodeLock.state.areOptionsAvailable

        for (index, element) in placeholders.enumerated() {
            element.isHidden = index >= passcodeConfiguration.passcodeLength
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func passcodeSignButtonTap(sender: PasscodeSignButton) {
        
        guard isPlaceholdersAnimationCompleted else { return }
        
        passcodeLock.addSign(sign: sender.passcodeSign)
    }
    
    @IBAction private func cancelButtonTap(sender: UIButton) {
        
        dismissPasscodeLock(lock: passcodeLock)
        cancelCallback?()
    }
    
    @IBAction private func deleteSignButtonTap(sender: UIButton) {
        
        passcodeLock.removeSign()
    }

    @IBAction private func optionsButtonTap(sender: UIButton) {

        let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let fourDigitsOption = UIAlertAction(title: "4-Digit Numeric Code", style: .default) { _ in

            let newConfiguration = PasscodeLockConfiguration(
                repository: self.passcodeConfiguration.repository,
                passcodeLength: 4,
                maximumInccorectPasscodeAttempts: self.passcodeConfiguration.maximumIncorrectPasscodeAttempts
            )

            self.passcodeConfiguration = newConfiguration
            self.passcodeLock = PasscodeLock(state: self.passcodeLock.state, configuration: newConfiguration)
            self.passcodeLock.delegate = self

            self.resetInputs()
            self.updatePasscodeView()
        }

        let sixDigitsOption = UIAlertAction(title: "6-Digit Numeric Code", style: .default) { _ in

            let newConfiguration = PasscodeLockConfiguration(
                repository: self.passcodeConfiguration.repository,
                passcodeLength: 6,
                maximumInccorectPasscodeAttempts: self.passcodeConfiguration.maximumIncorrectPasscodeAttempts
            )

            self.passcodeConfiguration = newConfiguration
            self.passcodeLock = PasscodeLock(state: self.passcodeLock.state, configuration: newConfiguration)
            self.passcodeLock.delegate = self

            self.resetInputs()
            self.updatePasscodeView()
        }

        let eightDigitsOption = UIAlertAction(title: "8-Digit Numeric Code", style: .default) { _ in

            let newConfiguration = PasscodeLockConfiguration(
                repository: self.passcodeConfiguration.repository,
                passcodeLength: 8,
                maximumInccorectPasscodeAttempts: self.passcodeConfiguration.maximumIncorrectPasscodeAttempts
            )

            self.passcodeConfiguration = newConfiguration
            self.passcodeLock = PasscodeLock(state: self.passcodeLock.state, configuration: newConfiguration)
            self.passcodeLock.delegate = self

            self.resetInputs()
            self.updatePasscodeView()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        vc.addAction(fourDigitsOption)
        vc.addAction(sixDigitsOption)
        vc.addAction(eightDigitsOption)

        vc.addAction(cancel)

        present(vc, animated: true, completion: nil)
    }

    internal func resetInputs() {

        for _ in 0 ..< passcodeConfiguration.passcodeLength { passcodeLock.removeSign() }

        animatePlaceholders(placeholders: placeholders, toState: .inactive, animated: false)
        deleteSignButton?.isEnabled = false
    }
    
    internal func dismissPasscodeLock(lock: PasscodeLockType, completionHandler: (() -> Void)? = nil) {
        
        // if presented as modal
        if presentingViewController?.presentedViewController == self {

            presentingViewController?.dismiss(animated: animateOnDismiss, completion: { [weak self] in
                
                self?.dismissCompletionCallback?()
                
                completionHandler?()
            })
            
            return
            
        // if pushed in a navigation controller
        } else if navigationController != nil {
        
            navigationController?.popViewController(animated: animateOnDismiss)
        }
        
        dismissCompletionCallback?()
        
        completionHandler?()
    }
    
    // MARK: - Animations
    
    internal func animateWrongPassword() {
        
        deleteSignButton?.isEnabled = false
        isPlaceholdersAnimationCompleted = false
        
        animatePlaceholders(placeholders: placeholders, toState: .error, animated: false)
        
        placeholdersX?.constant = -60
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.8, delay: 0,
            usingSpringWithDamping: 0.2, initialSpringVelocity: 0,
            options: [],
            animations: {
                
                self.placeholdersX?.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                
                self.isPlaceholdersAnimationCompleted = true
                self.animatePlaceholders(placeholders: self.placeholders, toState: .inactive, animated: true)
            }
        )
    }
    
    internal func animatePlaceholders(
        placeholders: [PasscodeSignPlaceholderView],
        toState state: PasscodeSignPlaceholderView.State,
        animated: Bool) {

        placeholders.forEach { $0.setState(state, animated: animated) }
    }
    
    private func animatePlacehodlerAtIndex(index: Int, toState state: PasscodeSignPlaceholderView.State) {
        
        guard index < placeholders.count && index >= 0 else { return }
        placeholders[index].setState(state, animated: true)
    }

    // MARK: - PasscodeLockDelegate
    
    public func passcodeLockDidSucceed(lock: PasscodeLockType) {

        successCallback?()
        dismissPasscodeLock(lock: lock, completionHandler: nil)
    }
    
    public func passcodeLockDidFail(lock: PasscodeLockType, failedAttempts: Int) {

        let failedAttemptsCount = failedAttempts
        let maxAttemptsCount = passcodeConfiguration.maximumIncorrectPasscodeAttempts

        guard maxAttemptsCount > 0 && failedAttemptsCount > 0 else {
            attemptsContainer.isHidden = true
            animateWrongPassword()
            return
        }

        attemptsContainer.isHidden = false
        attemptsLabel.text = String(format: "Passcode.FailedAttempt".localized, failedAttemptsCount)

        
        // TODO: - fix
        /*if failedAttemptsCount >= maxAttemptsCount {
            present(
                AccountBlockedViewController(username: Crypty.shared.currentUser?.username ?? ""),
                animated: true,
                completion: nil
            )
        } else {
            animateWrongPassword()
        }*/
    }
    
    public func passcodeLockDidChangeState(lock: PasscodeLockType) {
        updatePasscodeView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePlaceholders(placeholders: self.placeholders, toState: .inactive, animated: true)
            self.deleteSignButton?.isEnabled = false
        }
    }
    
    public func passcodeLock(lock: PasscodeLockType, addedSignAtIndex index: Int) {
        animatePlacehodlerAtIndex(index: index, toState: .active)
        deleteSignButton?.isEnabled = true
    }
    
    public func passcodeLock(lock: PasscodeLockType, removedSignAtIndex index: Int) {
        animatePlacehodlerAtIndex(index: index, toState: .inactive)
        if index == 0 { deleteSignButton?.isEnabled = false }
    }
}

