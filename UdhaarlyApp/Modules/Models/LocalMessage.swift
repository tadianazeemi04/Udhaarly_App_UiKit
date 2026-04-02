//
//  LocalMessage.swift
//  UdhaarlyApp
//

import Foundation
import SwiftData

/// Represents a single persistent message within a LocalChat.
/// It holds the exact content of the text and who sent it.
@Model
class LocalMessage {
    /// A unique identifier for the individual message.
    var id: UUID
    /// The identifier linking this message to its parent LocalChat.
    var chatId: UUID
    /// The email of the person who actually sent this message.
    var senderEmail: String
    /// The body text content of the message itself. Empty string when the message is photo-only.
    var content: String
    /// When the message was exactly created, used to order chat bubbles.
    var timestamp: Date
    /// A flag to determine if the message has been read by the recipient.
    var isRead: Bool = false
    /// A flag to indicate the message was delivered to the recipient's inbox (they opened the chat list).
    var isDelivered: Bool = false
    /// Optional compressed JPEG data for photo messages. Nil for text-only messages.
    var imageData: Data? = nil
    
    init(
        id: UUID = UUID(),
        chatId: UUID,
        senderEmail: String,
        content: String,
        timestamp: Date = Date(),
        isRead: Bool = false,
        isDelivered: Bool = false,
        imageData: Data? = nil
    ) {
        self.id = id
        self.chatId = chatId
        self.senderEmail = senderEmail
        self.content = content
        self.timestamp = timestamp
        self.isRead = isRead
        self.isDelivered = isDelivered
        self.imageData = imageData
    }
}
