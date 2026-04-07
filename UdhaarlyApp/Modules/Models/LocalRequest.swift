//
//  LocalRequest.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 26/03/2026.
//

import Foundation
import SwiftData

@Model
class LocalRequest {
    var id: UUID
    var productId: UUID
    var borrowerEmail: String
    var lenderEmail: String
    var status: String // "pending", "accepted", "cancelled", "returned", "delayed"
    var requestDate: Date
    var duration: String
    
    // Return Data
    var returnDate: Date?
    var returnCondition: String?
    @Attribute(.externalStorage) var returnImage: Data?
    
    // Review status
    var isReviewedByBorrower: Bool = false
    var isReviewedByLender: Bool = false
    
    // Delay Data
    var delayExtendedTime: String?
    var delayCondition: String?
    @Attribute(.externalStorage) var delayProductInUseImage: Data?
    @Attribute(.externalStorage) var delayPaymentSlipImage: Data?
    
    init(
        id: UUID = UUID(),
        productId: UUID,
        borrowerEmail: String,
        lenderEmail: String,
        status: String = "pending",
        requestDate: Date = Date(),
        duration: String
    ) {
        self.id = id
        self.productId = productId
        self.borrowerEmail = borrowerEmail
        self.lenderEmail = lenderEmail
        self.status = status
        self.requestDate = requestDate
        self.duration = duration
    }
}
