//
//  UserModel.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 02/03/2026.
//

import Foundation
import SwiftData

@Model
class LocalUser {
    @Attribute(.unique) var email: String
    var firstName: String
    var lastName: String
    var location: String
    var dob: String
    var profileImageData: Data?
    var registrationDate: Date
    
    init(email: String, firstName: String, lastName: String, location: String, dob: String,profileImageData: Data? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.dob = dob
        self.profileImageData = profileImageData
        self.registrationDate = Date()
    }
}
