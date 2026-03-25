//
//  LocalReview.swift
//  UdhaarlyApp
//

import Foundation
import SwiftData

@Model
class LocalReview {
    var id: UUID
    var reviewerName: String
    var reviewerEmail: String
    var revieweeEmail: String
    var rating: Int
    var title: String
    var body: String
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        reviewerName: String,
        reviewerEmail: String,
        revieweeEmail: String,
        rating: Int,
        title: String,
        body: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.reviewerName = reviewerName
        self.reviewerEmail = reviewerEmail
        self.revieweeEmail = revieweeEmail
        self.rating = rating
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }
}
