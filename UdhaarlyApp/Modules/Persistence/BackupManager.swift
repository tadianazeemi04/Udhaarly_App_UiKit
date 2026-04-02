//
//  BackupManager.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 02/04/2026.
//

import Foundation

// MARK: - Backup Data Structures

/// Lightweight Codable copy of a LocalUser for safe JSON backup.
struct UserBackupEntry: Codable {
    var email: String
    var firstName: String
    var lastName: String
    var location: String
    var phoneNumber: String
    var address: String
    var dob: String
    var password: String
    var registrationDate: Date
}

/// Lightweight Codable copy of a LocalProduct for safe JSON backup.
/// Image binary data is excluded to keep backup file size manageable.
struct ProductBackupEntry: Codable {
    var id: String
    var name: String
    var location: String
    var category: String
    var price: Double
    var duration: String
    var productDescription: String
    var highlights: String
    var isPremium: Bool
    var createdAt: Date
    var publisherEmail: String?
}

/// The root container for all backed-up data, written as a single JSON file.
struct BackupData: Codable {
    var backupDate: Date
    var appVersion: String
    var users: [UserBackupEntry]
    var products: [ProductBackupEntry]
}

// MARK: - BackupManager

/// Manages automatic JSON snapshots of critical app data stored in the Documents directory.
/// Survives SwiftData schema migrations and store wipes since it uses a completely
/// separate plain-JSON file.
class BackupManager {

    static let shared = BackupManager()

    private init() {}

    // MARK: - File Path

    /// The URL to the backup JSON file in the app's Documents folder.
    /// Documents folder persists across app launches and is NOT managed by SwiftData.
    var backupFileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("udhaarly_recovery_backup.json")
    }

    // MARK: - Debounce Support

    private var pendingBackupWork: DispatchWorkItem?

    /// Schedules a backup with a short debounce so rapid saves don't spam disk writes.
    /// - Parameter delay: Seconds to wait before writing. Default is 2 seconds.
    func scheduleBackup(delay: Double = 2.0) {
        pendingBackupWork?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.createBackup()
        }
        pendingBackupWork = work
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + delay, execute: work)
    }

    // MARK: - Create Backup

    /// Reads all current users and products from SwiftData and serializes them to a JSON file.
    func createBackup() {
        let users = LocalDataManager.shared.fetchAllUsers()
        let products = LocalDataManager.shared.fetchProducts()

        let userEntries: [UserBackupEntry] = users.map { u in
            UserBackupEntry(
                email: u.email,
                firstName: u.firstName,
                lastName: u.lastName,
                location: u.location,
                phoneNumber: u.phoneNumber,
                address: u.address,
                dob: u.dob,
                password: u.password,
                registrationDate: u.registrationDate
            )
        }

        let productEntries: [ProductBackupEntry] = products.map { p in
            ProductBackupEntry(
                id: p.id.uuidString,
                name: p.name,
                location: p.location,
                category: p.category,
                price: p.price,
                duration: p.duration,
                productDescription: p.productDescription,
                highlights: p.highlights,
                isPremium: p.isPremium,
                createdAt: p.createdAt,
                publisherEmail: p.publisherEmail
            )
        }

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let backup = BackupData(
            backupDate: Date(),
            appVersion: appVersion,
            users: userEntries,
            products: productEntries
        )

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(backup)
            try data.write(to: backupFileURL, options: .atomicWrite)
            print("✅ [BackupManager] Backup created: \(userEntries.count) users, \(productEntries.count) products.")
        } catch {
            print("❌ [BackupManager] Failed to write backup: \(error)")
        }
    }

    // MARK: - Read Backup Info

    /// Reads and returns the most recently saved backup without doing a restore.
    func loadBackup() -> BackupData? {
        guard FileManager.default.fileExists(atPath: backupFileURL.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: backupFileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(BackupData.self, from: data)
        } catch {
            print("❌ [BackupManager] Failed to read backup: \(error)")
            return nil
        }
    }

    // MARK: - Restore

    /// Restores all users and products from the backup JSON file into SwiftData.
    /// Skips records that already exist to avoid duplicates.
    /// - Returns: A tuple with the count of restored users and products.
    @discardableResult
    func restoreFromBackup() -> (restoredUsers: Int, restoredProducts: Int) {
        guard let backup = loadBackup() else {
            print("⚠️ [BackupManager] No backup file found.")
            return (0, 0)
        }

        var restoredUsers = 0
        var restoredProducts = 0

        // Restore Users
        for entry in backup.users {
            // Only insert if user doesn't already exist (avoid duplicating if partial data survived)
            if LocalDataManager.shared.fetchUser(email: entry.email) == nil {
                let user = LocalUser(
                    email: entry.email,
                    firstName: entry.firstName,
                    lastName: entry.lastName,
                    location: entry.location,
                    phoneNumber: entry.phoneNumber,
                    address: entry.address,
                    dob: entry.dob,
                    password: entry.password
                )
                LocalDataManager.shared.saveUser(user: user)
                restoredUsers += 1
            }
        }

        // Restore Products
        for entry in backup.products {
            guard let productId = UUID(uuidString: entry.id) else { continue }
            // Only insert if product with this ID doesn't already exist
            if LocalDataManager.shared.fetchProduct(id: productId) == nil {
                let product = LocalProduct(
                    id: productId,
                    name: entry.name,
                    location: entry.location,
                    category: entry.category,
                    price: entry.price,
                    duration: entry.duration,
                    productDescription: entry.productDescription,
                    highlights: entry.highlights,
                    isPremium: entry.isPremium,
                    createdAt: entry.createdAt,
                    publisherEmail: entry.publisherEmail
                )
                LocalDataManager.shared.saveProduct(product: product)
                restoredProducts += 1
            }
        }

        print("✅ [BackupManager] Restore complete: \(restoredUsers) users, \(restoredProducts) products.")
        return (restoredUsers, restoredProducts)
    }

    // MARK: - Delete Backup

    func deleteBackup() {
        try? FileManager.default.removeItem(at: backupFileURL)
    }
}
