//
//  LocalDataManager.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 02/03/2026.
//

import Foundation
import SwiftData

class LocalDataManager {
    
    static let shared = LocalDataManager()
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        /// Attempt to initialize the SwiftData ModelContainer with all managed entities including the new notification model.
        do {
            container = try ModelContainer(for: LocalUser.self, LocalProduct.self, LocalReview.self, LocalRequest.self, LocalNotification.self, LocalChat.self, LocalMessage.self)
            if let container = container {
                context = ModelContext(container)
            }
        } catch {
            /// Log any initialization failures for debugging purposes.
            print("Failed to initialize swiftdata: \(error)")
        }
        /// Clean up orphaned products to maintain database integrity.
        cleanupMissingPublisherProducts()
    }
    
    func fetchProducts() -> [LocalProduct] {
        let descriptor = FetchDescriptor<LocalProduct>(
            predicate: #Predicate { $0.isDeleted == false },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    /// Fetches all active products belonging to a specific category.
    func fetchProducts(byCategory category: String) -> [LocalProduct] {
        let descriptor = FetchDescriptor<LocalProduct>(
            predicate: #Predicate { $0.isDeleted == false && $0.category == category },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    func fetchProducts(forEmail email: String) -> [LocalProduct] {
        let descriptor = FetchDescriptor<LocalProduct>(
            predicate: #Predicate { $0.isDeleted == false && $0.publisherEmail == email },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    func fetchReviews(forEmail email: String) -> [LocalReview] {
        let descriptor = FetchDescriptor<LocalReview>(
            predicate: #Predicate { $0.revieweeEmail == email },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let reviews = (try? context?.fetch(descriptor)) ?? []
        
        // Seed some dummy reviews if none exist for this user
        if reviews.isEmpty {
            seedDummyReviews(forEmail: email)
            return fetchReviews(forEmail: email)
        }
        
        return reviews
    }
    
    private func seedDummyReviews(forEmail email: String) {
        let dummyReviews = [
            LocalReview(reviewerName: "Sana Khan", reviewerEmail: "sana@example.com", revieweeEmail: email, rating: 5, title: "Great Experience", body: "The product was in perfect condition and the communication was smooth."),
            LocalReview(reviewerName: "Zain Ali", reviewerEmail: "zain@example.com", revieweeEmail: email, rating: 4, title: "Recommended", body: "Good service and timely response. Highly recommended for rentals."),
            LocalReview(reviewerName: "Ayesha Ahmed", reviewerEmail: "ayesha@example.com", revieweeEmail: email, rating: 5, title: "Very Helpful", body: "Very polite and helpful user. Everything went as planned.")
        ]
        
        for review in dummyReviews {
            context?.insert(review)
        }
        try? context?.save()
    }
    
    func fetchDeletedProducts() -> [LocalProduct] {
        let descriptor = FetchDescriptor<LocalProduct>(
            predicate: #Predicate { $0.isDeleted == true },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    func fetchFavorites() -> [LocalProduct] {
        let descriptor = FetchDescriptor<LocalProduct>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    func saveContext() {
        try? context?.save()
        // Automatically update the JSON recovery backup after every data change.
        // The 2-second debounce prevents spamming disk writes for rapid saves.
        BackupManager.shared.scheduleBackup()
    }

    func fetchAllUsers() -> [LocalUser] {
        let descriptor = FetchDescriptor<LocalUser>()
        return (try? context?.fetch(descriptor)) ?? []
    }

    func saveUser(user: LocalUser) {
        context?.insert(user)
        try? context?.save()
    }
    
    func saveProduct(product: LocalProduct) {
        context?.insert(product)
        try? context?.save()
    }
    
    func saveReview(review: LocalReview) {
        context?.insert(review)
        saveContext()
    }
    
    func deleteProduct(product: LocalProduct) {
        product.isDeleted = true
        try? context?.save()
    }
    
    func permanentlyDeleteProduct(product: LocalProduct) {
        context?.delete(product)
        try? context?.save()
    }
    
    func restoreProduct(product: LocalProduct) {
        product.isDeleted = false
        try? context?.save()
    }
    
    func fetchUser(email: String) -> LocalUser? {
        let descriptor = FetchDescriptor<LocalUser>(predicate: #Predicate { $0.email == email })
        return try? context?.fetch(descriptor).first
    }
    
    // MARK: - Requests Logic
    func saveRequest(request: LocalRequest) {
        context?.insert(request)
        try? context?.save()
        
        /// Trigger a notification for the lender when someone wants to borrow their item.
        NotificationManager.shared.postNotification(
            title: "New Borrow Request",
            body: "Someone wants to borrow your item. Tap to view.",
            recipientEmail: request.lenderEmail,
            type: "request",
            relatedId: request.productId.uuidString
        )
    }
    
    func fetchRequests(forEmail email: String, isLender: Bool) -> [LocalRequest] {
        if isLender {
            let descriptor = FetchDescriptor<LocalRequest>(
                predicate: #Predicate { $0.lenderEmail == email },
                sortBy: [SortDescriptor(\.requestDate, order: .reverse)]
            )
            return (try? context?.fetch(descriptor)) ?? []
        } else {
            let descriptor = FetchDescriptor<LocalRequest>(
                predicate: #Predicate { $0.borrowerEmail == email },
                sortBy: [SortDescriptor(\.requestDate, order: .reverse)]
            )
            return (try? context?.fetch(descriptor)) ?? []
        }
    }
    
    func hasExistingRequest(productId: UUID, borrowerEmail: String) -> Bool {
        let descriptor = FetchDescriptor<LocalRequest>(
            predicate: #Predicate { $0.productId == productId && $0.borrowerEmail == borrowerEmail && $0.status == "pending" }
        )
        let count = (try? context?.fetchCount(descriptor)) ?? 0
        return count > 0
    }
    
    func updateRequestStatus(request: LocalRequest, status: String) {
        request.status = status
        saveContext()
        
        /// Notify the borrower of the lender's decision or status update.
        let statusTitle = status == "accepted" ? "Request Accepted! 🎉" : "Request Update"
        let statusBody = "Your request for the item has been updated to '\(status)'."
        
        NotificationManager.shared.postNotification(
            title: statusTitle,
            body: statusBody,
            recipientEmail: request.borrowerEmail,
            type: "request",
            relatedId: request.productId.uuidString
        )
    }
    
    func updateRequestReturn(request: LocalRequest, condition: String, image: Data) {
        request.returnDate = Date()
        request.returnCondition = condition
        request.returnImage = image
        request.status = "returned"
        saveContext()
        
        /// Alert the lender that their item has been returned and needs inspection.
        NotificationManager.shared.postNotification(
            title: "Item Returned",
            body: "An item has been returned by the borrower. Please inspect it.",
            recipientEmail: request.lenderEmail,
            type: "request",
            relatedId: request.productId.uuidString
        )
    }
    
    /// Updates a request with delay details and notifies the lender.
    /// - Parameters:
    ///   - request: The LocalRequest being modified.
    ///   - extendedTime: The additional time requested.
    ///   - condition: The current status of the item.
    ///   - productInUseImage: Evidence of the product currently being used.
    ///   - paymentSlipImage: Proof of secondary payment for the extension.
    func updateRequestDelay(request: LocalRequest, extendedTime: String, condition: String, productInUseImage: Data, paymentSlipImage: Data) {
        request.delayExtendedTime = extendedTime
        request.delayCondition = condition
        request.delayProductInUseImage = productInUseImage
        request.delayPaymentSlipImage = paymentSlipImage
        request.status = "delayed"
        saveContext()
        
        /// Notify the lender about a delay request.
        NotificationManager.shared.postNotification(
            title: "Delay Requested",
            body: "A borrower has requested a delay for your item. Tap to view details.",
            recipientEmail: request.lenderEmail,
            type: "request",
            relatedId: request.productId.uuidString
        )
    }
    
    func fetchProduct(id: UUID) -> LocalProduct? {
        let descriptor = FetchDescriptor<LocalProduct>(predicate: #Predicate { $0.id == id })
        return try? context?.fetch(descriptor).first
    }

    func fetchAcceptedRequest(productId: UUID) -> LocalRequest? {
        let descriptor = FetchDescriptor<LocalRequest>(
            predicate: #Predicate { $0.productId == productId && $0.status == "accepted" }
        )
        return try? context?.fetch(descriptor).first
    }
    
    func fetchPendingRequestsCount(forEmail email: String) -> Int {
        let borrowDescriptor = FetchDescriptor<LocalRequest>(
            predicate: #Predicate { $0.borrowerEmail == email && $0.status == "pending" }
        )
        let lendDescriptor = FetchDescriptor<LocalRequest>(
            predicate: #Predicate { $0.lenderEmail == email && $0.status == "pending" }
        )
        
        let borrowCount = (try? context?.fetchCount(borrowDescriptor)) ?? 0
        let lendCount = (try? context?.fetchCount(lendDescriptor)) ?? 0
        
        return borrowCount + lendCount
    }
    
    // MARK: - Notifications Logic
    
    /// Saves a newly created notification to the persistent store.
    /// - Parameter notification: The LocalNotification instance to persist.
    func saveNotification(notification: LocalNotification) {
        context?.insert(notification)
        saveContext()
    }
    
    /// Retrieves all notifications for a specific user, ordered by creation date (newest first).
    /// - Parameter email: The email address of the recipient.
    /// - Returns: An array of LocalNotification objects.
    func fetchNotifications(forEmail email: String) -> [LocalNotification] {
        let descriptor = FetchDescriptor<LocalNotification>(
            predicate: #Predicate { $0.recipientEmail == email },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    /// Counts unread notifications for a user to update badge UI.
    /// - Parameter email: The email address of the user.
    /// - Returns: The integer count of unread notifications.
    func fetchUnreadNotificationsCount(forEmail email: String) -> Int {
        let descriptor = FetchDescriptor<LocalNotification>(
            predicate: #Predicate { $0.recipientEmail == email && $0.isRead == false }
        )
        return (try? context?.fetchCount(descriptor)) ?? 0
    }
    
    /// Marks all unread notifications as read to clear badges.
    /// - Parameter email: The email address of the recipient.
    func markAllNotificationsAsRead(forEmail email: String) {
        let notifications = fetchNotifications(forEmail: email)
        for notification in notifications {
            notification.isRead = true
        }
        saveContext()
    }
    
    /// Deletes a specific notification from persistence.
    /// - Parameter notification: The notification to permanently remove.
    func deleteNotification(notification: LocalNotification) {
        context?.delete(notification)
        saveContext()
    }
    
    private func cleanupMissingPublisherProducts() {
        // Fetch all products
        let descriptor = FetchDescriptor<LocalProduct>()
        let products = (try? context?.fetch(descriptor)) ?? []
        
        // Fetch all users to verify emails
        let userDescriptor = FetchDescriptor<LocalUser>()
        let users = (try? context?.fetch(userDescriptor)) ?? []
        let existingEmails = Set(users.map { $0.email })
        
        for product in products {
            if let email = product.publisherEmail {
                if !existingEmails.contains(email) {
                    context?.delete(product)
                }
            } else {
                // Remove products with nil publisher email as well
                context?.delete(product)
            }
        }
        saveContext()
    }
    // MARK: - Chat & Messaging Logic
    
    /// Initiates a brand new persistent chat thread between two users.
    /// - Parameters:
    ///   - productId: The product this inquiry is about.
    ///   - participant1: First user in the chat.
    ///   - participant2: Expected product owner or second user.
    /// - Returns: The newly created `LocalChat` instance.
    func createChat(productId: UUID?, participant1: String, participant2: String) -> LocalChat {
        let newChat = LocalChat(productId: productId, participant1Email: participant1, participant2Email: participant2)
        context?.insert(newChat)
        saveContext()
        return newChat
    }
    
    /// Fetches the list of conversations involving the given email to populate the Chats Inbox.
    /// The chats are ordered with the most recently active ones appearing first.
    func fetchChats(forEmail email: String) -> [LocalChat] {
        let descriptor = FetchDescriptor<LocalChat>(
            predicate: #Predicate { $0.participant1Email == email || $0.participant2Email == email },
            sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    /// Searches for an existing conversation between two specific users about a product.
    /// SwiftData predicates sometimes fail with loose OR logic and optionals,
    /// so this manually checks participant combinations efficiently.
    func fetchChat(productId: UUID?, participant1: String, participant2: String) -> LocalChat? {
        let chats = fetchChats(forEmail: participant1)
        return chats.first { chat in
            let matchesParticipant2 = chat.participant1Email == participant2 || chat.participant2Email == participant2
            return matchesParticipant2 && chat.productId == productId
        }
    }
    
    /// Commits a new underlying `LocalMessage` to SwiftData and updates its parent `LocalChat`.
    /// - Parameters:
    ///   - chatId: Link to the `LocalChat` model this message is for.
    ///   - senderEmail: The current logged user's email sending the text.
    ///   - content: The actual text being sent. Empty string for photo-only messages.
    ///   - imageData: Optional JPEG data for photo messages. Nil for text-only messages.
    func sendMessage(chatId: UUID, senderEmail: String, content: String, imageData: Data? = nil) {
        let message = LocalMessage(chatId: chatId, senderEmail: senderEmail, content: content, imageData: imageData)
        context?.insert(message)
        
        let descriptor = FetchDescriptor<LocalChat>(predicate: #Predicate { $0.id == chatId })
        if let chat = (try? context?.fetch(descriptor))?.first {
            // Show a photo placeholder in the inbox preview if it's a photo-only message
            chat.lastMessage = imageData != nil && content.isEmpty ? "📸 Photo" : content
            chat.lastUpdated = Date()
        }
        
        saveContext()
    }
    
    /// Given a chat ID, pulls out all the historically sent messages from oldest to newest.
    /// This is used to render the scrolling chat bubbles in the Detail Controller.
    func fetchMessages(forChatId chatId: UUID) -> [LocalMessage] {
        let descriptor = FetchDescriptor<LocalMessage>(
            predicate: #Predicate { $0.chatId == chatId },
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        return (try? context?.fetch(descriptor)) ?? []
    }
    
    // MARK: - Read Receipt Logic
    
    /// Marks all messages NOT sent by `recipientEmail` across all their chats as "delivered".
    /// Called when the recipient opens the Chats inbox — simulating delivery confirmation.
    /// - Parameter recipientEmail: The logged-in user who just opened their inbox.
    func markMessagesAsDelivered(for recipientEmail: String) {
        let chats = fetchChats(forEmail: recipientEmail)
        for chat in chats {
            let messages = fetchMessages(forChatId: chat.id)
            for message in messages where message.senderEmail != recipientEmail && !message.isDelivered {
                message.isDelivered = true
            }
        }
        saveContext()
    }
    
    /// Marks all messages NOT sent by `recipientEmail` in a specific chat as both delivered and read.
    /// Called when the recipient opens a specific chat — simulating the read confirmation.
    /// - Parameters:
    ///   - chatId: The chat the user just opened.
    ///   - recipientEmail: The logged-in user who just opened the chat.
    func markMessagesAsRead(chatId: UUID, recipientEmail: String) {
        let messages = fetchMessages(forChatId: chatId)
        for message in messages where message.senderEmail != recipientEmail {
            if !message.isDelivered { message.isDelivered = true }
            if !message.isRead { message.isRead = true }
        }
        saveContext()
    }

}

