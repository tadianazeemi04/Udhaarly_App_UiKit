//
//  LocalChat.swift
//  UdhaarlyApp
//

import Foundation
import SwiftData

/// Represents a persistent chat conversation between two users in the app.
/// This acts as the parent object holding metadata about the chat such as the participants
/// and the overall timestamp to keep the list ordered.
@Model
class LocalChat {
    /// A unique identifier for the chat.
    var id: UUID
    /// An optional identifier to specify if this chat is regarding a specific product.
    var productId: UUID?
    /// The email identifier of the first participant.
    var participant1Email: String
    /// The email identifier of the second participant.
    var participant2Email: String
    /// A quick preview of the last message sent, stored here to prevent having to load all child messages just to show the list.
    var lastMessage: String?
    /// The date the last message was sent, used for sorting the chat groups in ChatsViewController.
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        productId: UUID? = nil,
        participant1Email: String,
        participant2Email: String,
        lastMessage: String? = nil,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.productId = productId
        self.participant1Email = participant1Email
        self.participant2Email = participant2Email
        self.lastMessage = lastMessage
        self.lastUpdated = lastUpdated
    }
}
