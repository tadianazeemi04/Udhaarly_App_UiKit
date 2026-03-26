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
        do {
            container = try ModelContainer(for: LocalUser.self, LocalProduct.self, LocalReview.self, LocalRequest.self)
            if let container = container {
                context = ModelContext(container)
            }
        } catch {
            print("Failed to initialize swiftdata: \(error)")
        }
        cleanupMissingPublisherProducts()
    }
    
    func fetchProducts() -> [LocalProduct] {
        let descriptor = FetchDescriptor<LocalProduct>(
            predicate: #Predicate { $0.isDeleted == false },
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
    }
    
    func updateRequestReturn(request: LocalRequest, condition: String, image: Data) {
        request.returnDate = Date()
        request.returnCondition = condition
        request.returnImage = image
        request.status = "returned"
        saveContext()
    }
    
    func updateRequestDelay(request: LocalRequest, extendedTime: String, condition: String, productInUseImage: Data, paymentSlipImage: Data) {
        request.delayExtendedTime = extendedTime
        request.delayCondition = condition
        request.delayProductInUseImage = productInUseImage
        request.delayPaymentSlipImage = paymentSlipImage
        request.status = "delayed"
        saveContext()
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
    
}

