//
//  UIApplication+SafeAreas.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

extension UIApplication {

    /// Check if the application runs on iPhone X like phones
    static var isDeviceWithSafeArea: Bool {
        if let topPadding = keyWindowIOS13Safe?.safeAreaInsets.bottom, topPadding > 0 {
            return true
        }
        return false
    }

    /// Get the safe area insets if available
    static var safeAreaInsets: UIEdgeInsets {
        if let safeAreaInsets = keyWindowIOS13Safe?.safeAreaInsets {
            return safeAreaInsets
        }
        return .zero
    }

    static var areRemoteNotificationsEnabled: Bool {

        guard shared.isRegisteredForRemoteNotifications else { return false }
        guard let settings = shared.currentUserNotificationSettings else { return false }

        return !settings.types.isEmpty
    }

    static var keyWindowIOS13Safe: UIWindow? {

        guard #available(iOS 13.0, *) else {
            return UIApplication.shared.keyWindow
        }

        return UIApplication.shared.connectedScenes
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .first { $0.isKeyWindow }
    }
}

