//
//  LocalProduct.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 05/03/2026.
//

import Foundation
import SwiftData

@Model
class LocalProduct {
    var id: UUID
    var name: String
    var location: String
    var category: String
    var price: Double
    var duration: String // e.g., "1 Day", "1 Week"
    var productDescription: String
    var highlights: String

    // Store images as Data (Binary) for local persistence
    @Attribute(.externalStorage) var coverImage: Data? // the buyer promotion image
    var galleryImages: [Data]
    var isPremium: Bool
    var isFavorite: Bool = false
    var createdAt: Date
    var publisherEmail: String?
    var isDeleted: Bool = false

    init(
        id: UUID = UUID(),
        name: String,
        location: String,
        category: String,
        price: Double,
        duration: String,
        productDescription: String,
        highlights: String,
        coverImage: Data? = nil,
        galleryImages: [Data] = [],
        isPremium: Bool = false,
        isFavorite: Bool = false,
        createdAt: Date = Date(),
        publisherEmail: String? = nil,
        isDeleted: Bool = false
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.category = category
        self.price = price
        self.duration = duration
        self.productDescription = productDescription
        self.highlights = highlights
        self.coverImage = coverImage
        self.galleryImages = galleryImages
        self.isPremium = isPremium
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.publisherEmail = publisherEmail
        self.isDeleted = isDeleted
    }
}
