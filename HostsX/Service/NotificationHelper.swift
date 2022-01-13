//
//  NotificationHelper.swift
//  HostsX
//
//  Created by zm on 2021/12/22.
//

import Foundation
import UserNotifications

enum NotificationCategory {
    case loacl, remote
    var title: String {
        switch self {
        case .loacl: return Localization.Menu.local
        case .remote: return Localization.Menu.remote
        }
    }
}

struct NotificationHelper {

    static func deliver(category: NotificationCategory, error: Error?) {
        var title = Localization.Update.succeeded, body = Localization.Update.finished
        defer { deliver(category.title + title, body: body) }
        guard error != nil else { return }
        if case .cancelled = error as? HostsError {
            title = Localization.Update.unfinished
        } else {
            title = Localization.Update.failed
        }
        body = error!.localizedDescription
    }

    static func deliver(_ title: String, body: String) {
        if #available(macOS 10.14, *) {
            unDeliver(title, body: body)
        } else {
            nsDeliver(title, body: body)
        }
    }

    @available(macOS 10.14, *)
    private static func unDeliver(_ title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization {
            center.delegate =  NotificationDelegate.default
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.3, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: .none)
        }
    }


    private static func nsDeliver(_ title: String, body: String) {
        let center = NSUserNotificationCenter.default
        center.delegate = NotificationDelegate.default
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = body
        notification.soundName = NSUserNotificationDefaultSoundName
        center.deliver(notification)
    }

}

@available(macOS 10.14, *)
extension UNUserNotificationCenter {
    func requestAuthorization(completion: @escaping VoidClosure) {
        getNotificationSettings { [weak self] in
            guard let strong = self else { return }
            switch $0.authorizationStatus {
            case .authorized, .provisional: completion()
            case .notDetermined:
                strong.requestAuthorization(options: [.alert, .sound]) {
                    if $1 != nil { return }
                    if $0 { completion() }
                }
            case .denied: return
            @unknown default: completion()
            }
        }
    }
}


class NotificationDelegate: NSObject {
    static let `default` = NotificationDelegate()
}

extension NotificationDelegate: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        true
    }
}

@available(macOS 10.14, *)
extension NotificationDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(macOS 11.0, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }
}


