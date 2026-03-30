//
//  LocalNotification.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 27/03/2026.
//

import Foundation
import SwiftData

/// LocalNotification represents a user notification stored locally using SwiftData.
@Model
class LocalNotification {
    /// Unique identifier for each notification.
    @Attribute(.unique) var id: UUID
    
    /// The display title of the notification (e.g., "New Borrow Request").
    var title: String
    
    /// The descriptive body text of the notification.
    var body: String
    
    /// The timestamp when the notification was generated.
    var createdAt: Date
    
    /// Flag indicating whether the user has viewed this notification.
    var isRead: Bool
    
    /// The email address of the user who should receive this notification.
    var recipientEmail: String
    
    /// Type categorization (e.g., "request", "chat", "system") to allow filtering and custom icons.
    var type: String
    
    /// Optional identifier linking this notification to a specific request ID for easy navigation.
    var relatedId: String?
    
    /// Initializes a new notification instance.
    /// - Parameters:
    ///   - title: The headline for the alert.
    ///   - body: The main message content.
    ///   - recipientEmail: The user this notification belongs to.
    ///   - type: The category (request, chat, etc.).
    ///   - relatedId: Optional UID for navigation context.
    init(title: String, body: String, recipientEmail: String, type: String = "system", relatedId: String? = nil) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.createdAt = Date()
        self.isRead = false
        self.recipientEmail = recipientEmail
        self.type = type
        self.relatedId = relatedId
    }
}
