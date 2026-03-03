//
//  KeychainHelper.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 02/03/2026.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    
    func save(_ data: String, account: String) {
        let value = data.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: value
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
}
