//
//  NotificationManager.swift
//  UdhaarlyApp
//
//  Created by Antigravity on 27/03/2026.
//

import Foundation
import UserNotifications
import UIKit

/// NotificationManager coordinates both in-app banners and system-level local notifications.
class NotificationManager: NSObject {
    
    /// Static shared instance for app-wide access.
    static let shared = NotificationManager()
    
    /// Private initializer to enforce singleton pattern.
    private override init() {
        super.init()
        /// [DISABLED] Delegate registration for system notifications.
        // UNUserNotificationCenter.current().delegate = self
    }
    
    /// Requests permission from the user to display system-level alerts and sounds.
    func requestAuthorization() {
        /// [DISABLED] System notification authorization is no longer required for in-app banners.
        /*
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                /// Successfully obtained permission for local notifications.
                print("Notification permission granted.")
            } else if let error = error {
                /// Log any errors during the authorization request.
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
        */
    }
    
    /// Sends a notification to a specific user, saves it to persistence, and displays an alert.
    /// - Parameters:
    ///   - title: Short headline of the alert.
    ///   - body: Verbose message content.
    ///   - recipientEmail: The targeted user's unique email.
    ///   - type: Category of notification (e.g., "request", "message").
    ///   - relatedId: Optional ID relating to a product or request for deep linking.
    func postNotification(title: String, body: String, recipientEmail: String, type: String = "system", relatedId: String? = nil) {
        
        /// 1. Create and persist the notification in SwiftData.
        let localNotification = LocalNotification(
            title: title,
            body: body,
            recipientEmail: recipientEmail,
            type: type,
            relatedId: relatedId
        )
        LocalDataManager.shared.saveNotification(notification: localNotification)
        
        /// 2. Post a local broadcast to notify UI components (like the bell icon badge) to refresh.
        NotificationCenter.default.post(name: .didReceiveNewNotification, object: nil)
        
        /// 3. Display an In-App Popup if the user is currently using the app.
        DispatchQueue.main.async {
            self.showInAppBanner(title: title, body: body)
        }
        
        /// 4. [DISABLED] Schedule a system-level notification for lock screen visibility.
        // scheduleSystemNotification(title: title, body: body)
    }
    
    /// Displays a temporary premium banner at the top of the current screen.
    /// - Parameters:
    ///   - title: The banner's bold title.
    ///   - body: The banner's subtitle or body text.
    private func showInAppBanner(title: String, body: String) {
        /// Instantiate and animate the premium InAppNotificationView banner.
        InAppNotificationView.show(title: title, body: body)
    }
    
    /// Triggers a native iOS alert banner via UNUserNotificationCenter.
    /// - Parameters:
    ///   - title: The title for the system banner.
    ///   - body: The message text for the system banner.
    private func scheduleSystemNotification(title: String, body: String) {
        /// [DISABLED] System notification scheduling.
        /*
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        /// Trigger the notification immediately with a 1-second delay.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                /// Handle failures in scheduling system notifications.
                print("Error scheduling system notification: \(error)")
            }
        }
        */
    }
}

/// Extension to handle foreground notification display behavior.
/* [DISABLED] UNUserNotificationCenterDelegate implementation.
extension NotificationManager: UNUserNotificationCenterDelegate {
    /// Determines how notifications are presented when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /// Show both sound and banner even if the app is open.
        completionHandler([.banner, .sound])
    }
}
*/

/// Unique notification names used for internal app broadcasts.
extension NSNotification.Name {
    /// Dispatched when a new notification is added to the database.
    static let didReceiveNewNotification = NSNotification.Name("didReceiveNewNotification")
}
