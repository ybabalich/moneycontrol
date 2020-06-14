//
//  PasscodeSettingView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 02.05.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

protocol PasscodeSettingsViewModelDelegate: class {
    func setNeedsReloadContent()
}

class PasscodeSettingsViewModel: NSObject {

    weak var controller: (UIViewController & PasscodeSettingsViewModelDelegate)?

    //
    // MARK: - Content Builder

    enum SectionName {
        case general, utilities

        var displayName: String {
            switch self {
            case .general: return ""
            case .utilities: return ""
            }
        }

        var footerNote: String? {
            switch self {
            case .general: return nil
            case .utilities: return "Shorter periods are more secure."
            }
        }
    }

    enum RowName {

        case turnOn, turnOff, changeCode
        case autolock

        var displayName: String {
            switch self {
            case .turnOn: return "Turn PIN On"
            case .turnOff: return "Turn PIN Off"
            case .changeCode: return "Change PIN"
            case .autolock: return "Ask PIN"
            }
        }
    }

    struct Section {
        var name: SectionName
        var rows: [RowName]
    }

    //

    private let turnedOffSections: [Section] = [
        Section(name: .general, rows: [.turnOn])
    ]

    private let turnedOnSections: [Section] = [
        Section(name: .general, rows: [.turnOff, .changeCode]),
        Section(name: .utilities, rows: [.autolock])
    ]

    var sections: [Section] {

        let isPinEnabled = Money.instance.settings.isPINCodeProtected

        if isPinEnabled { return turnedOnSections
        } else { return turnedOffSections }
    }

    //
    // MARK: - Object Lifecycle

    override init() {
        super.init()
//        observeSocket(for: .getUser, .updatePINTimeout)
    }
}

//
// MARK: - User Interactions

extension PasscodeSettingsViewModel {

    func userTappedEnablePasscode() {
        Router.instance.presentPasscodeVC(mode: .setNew)
    }

    func userTappedDisablePasscode() {

        let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let turnOff = UIAlertAction(title: "Turn PIN Off", style: .destructive) { _ in
//            User.updatePIN(nil)
        }

        vc.addAction(turnOff)
        vc.addAction(cancel)

        controller?.present(vc, animated: true, completion: nil)
    }

    func userTappedChangePasscode() {
        Router.instance.presentPasscodeVC(mode: .setNew)
    }

    func userTappedRequirePasscode() {
//        Router.instance.showRequirePasscodeOptionsPage()
    }
}

extension PasscodeSettingsViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].name.displayName
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].name.footerNote
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        guard let user = Crypty.shared.currentUser else { fatalError("Should not ever happen!") }
        guard
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].rows.count
        else { return UITableViewCell() }

        let style: UITableViewCell.CellStyle = .value1

        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        let identifier = "\(style.rawValue)"

        //

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            ?? UITableViewCell(style: style, reuseIdentifier: identifier)

        //
        // Calculating cell content.

        switch section.name {
        case .general:

            switch row {
            case .turnOn, .turnOff:
                updateCell(cell, selectionStyle: .default, text: row.displayName, textColor: .controlTintActive)

            case .changeCode:
                updateCell(cell,
                           accessoryType: .disclosureIndicator,
                           selectionStyle: .default,
                           text: row.displayName, textColor: .controlTintActive)

            default: fatalError("Should not ever happen!")
            }

        case .utilities:
            print("utilities")
//            switch row {
//            case .autolock:
//
//                let descriptionText: String
//                if user.requirePasscodeAfter.magnitude == .never { descriptionText = "Immediately"
//                } else { descriptionText = "When away for \(user.requirePasscodeAfter.localized)" }
//
//                updateCell(cell,
//                           accessoryType: .disclosureIndicator,
//                           selectionStyle: .default,
//                           text: row.displayName,
//                           secondaryText: descriptionText)
//
//            default: fatalError("Should not ever happen!")
//            }
        }

        return cell
    }

    //

    private func updateCell(
        _ cell: UITableViewCell,

        accessoryType: UITableViewCell.AccessoryType = .none,
        accessoryView: UIView? = nil,
        selectionStyle: UITableViewCell.SelectionStyle = .none,

        text: String? = nil,
        textColor: UIColor? = .primaryText,

        secondaryText: String? = nil,
        secondaryTextColor: UIColor? = .secondaryText) {

        cell.backgroundColor = .clear //.cellBackground
        cell.selectedBackgroundView = UIView().then { $0.backgroundColor = .clear }

        //

        cell.accessoryType = accessoryType
        cell.accessoryView = accessoryView
        cell.selectionStyle = selectionStyle

        cell.textLabel?.text = text
        cell.textLabel?.textColor = textColor
        cell.textLabel?.numberOfLines = 1

        cell.detailTextLabel?.text = secondaryText
        cell.detailTextLabel?.textColor = secondaryTextColor
        cell.detailTextLabel?.numberOfLines = 1
    }
}

/*extension PasscodeSettingsViewModel: SocketActionObserver {

    func socketDidReceiveResponse(for event: SocketAPI.Event, data: JSON) {
        let response = responseFrom(event: event, data: data)

        switch response {
        case .getUser(let result): handleGetUser(result)
        case .updatePINTimeout(let result): handleUpdatePINTimeout(result)

        default:
            if isDebug { fatalError("Event response is not handled: \(event)")
            } else { break }
        }
    }

    func handleGetUser(_ result: SingleResult<User>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.controller?.setNeedsReloadContent()
        }
    }

    func handleUpdatePINTimeout(_ result: SingleResult<User.ExpirationOption>) {

        switch result {
        case .success(let timeout): Crypty.shared.currentUser?.requirePasscodeAfter = timeout
        case .failure: break
        }

        controller?.setNeedsReloadContent()
    }
}*/

