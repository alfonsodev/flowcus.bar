//
//  AppDelegate+Notifications.swift
//  flowcus
//
//  Created by Alfonso on 03.05.18.
//  Copyright © 2018 Codefulness. All rights reserved.
//

import Cocoa
extension AppDelegate {

    func showNotification() {
        let notification = NSUserNotification()
        notification.title = "𝓕lowcus."
        notification.subtitle = "✅ Complete"
        NSUserNotificationCenter.default.delegate = self as NSUserNotificationCenterDelegate
        NSUserNotificationCenter.default.deliver(notification)
    }

    func showNotificationConfirm() {
        let notification = NSUserNotification()
        notification.title = "𝓕lowcus."
        notification.subtitle = "What are you gonna do ?"
        notification.hasActionButton = true
        notification.hasReplyButton = true
        notification.actionButtonTitle = "cancel"

        NSUserNotificationCenter.default.delegate = self as NSUserNotificationCenterDelegate
        NSUserNotificationCenter.default.deliver(notification)
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        // print(notification.response)
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
