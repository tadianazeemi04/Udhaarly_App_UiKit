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
            container = try ModelContainer(for: LocalUser.self, LocalProduct.self)
            if let container = container {
                context = ModelContext(container)
            }
        } catch {
            print("Failed to initialize swiftdata: \(error)")
        }
    }
    
    func fetchProducts() -> [LocalProduct] {
        let descriptor = FetchDescriptor<LocalProduct>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
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
    
    func fetchUser(email: String) -> LocalUser? {
        let descriptor = FetchDescriptor<LocalUser>(predicate: #Predicate { $0.email == email })
        return try? context?.fetch(descriptor).first
    }
    
}

