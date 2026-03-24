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
    var phoneNumber: String = ""
    var address: String = ""
    var dob: String
    var profileImageData: Data?
    var registrationDate: Date
    var password: String = ""
    
    init(email: String, firstName: String, lastName: String, location: String, phoneNumber: String = "", address: String = "", dob: String, password: String = "", profileImageData: Data? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.phoneNumber = phoneNumber
        self.address = address
        self.dob = dob
        self.password = password
        self.profileImageData = profileImageData
        self.registrationDate = Date()
    }
}
