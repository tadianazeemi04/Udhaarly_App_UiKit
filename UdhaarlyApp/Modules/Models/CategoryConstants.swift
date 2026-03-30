//
//  CategoryConstants.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 30/03/2026.
//

import Foundation
import UIKit

/// Unified categories used across the Udhaarly application.
enum Category: String, CaseIterable {
    case all = "All"
    case software = "Software"
    case homeDecor = "Home & Decor"
    case electronics = "Electronics"
    case furniture = "Furniture"
    case fashion = "Fashion"
    case books = "Books"
    case mobile = "Mobile"
    case other = "Other"
    
    /// SF Symbol icon name for the category.
    var iconName: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .software: return "apps.iphone"
        case .homeDecor: return "house.fill"
        case .electronics: return "desktopcomputer"
        case .furniture: return "chair.lounge.fill"
        case .fashion: return "tshirt.fill"
        case .books: return "book.fill"
        case .mobile: return "iphone"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    /// A soft, pastel theme color for the category background.
    var themeColor: UIColor {
        switch self {
        case .all: return UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1.0)
        case .software: return UIColor(red: 232/255, green: 245/255, blue: 255/255, alpha: 1.0)
        case .homeDecor: return UIColor(red: 232/255, green: 255/255, blue: 245/255, alpha: 1.0)
        case .electronics: return UIColor(red: 245/255, green: 232/255, blue: 255/255, alpha: 1.0)
        case .furniture: return UIColor(red: 255/255, green: 245/255, blue: 232/255, alpha: 1.0)
        case .fashion: return UIColor(red: 255/255, green: 232/255, blue: 245/255, alpha: 1.0)
        case .books: return UIColor(red: 255/255, green: 255/255, blue: 232/255, alpha: 1.0)
        case .mobile: return UIColor(red: 232/255, green: 255/255, blue: 255/255, alpha: 1.0)
        case .other: return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }
    }
    
    /// A darker version of the theme color for icons or text.
    var accentColor: UIColor {
        switch self {
        case .all: return .systemGray
        case .software: return .systemBlue
        case .homeDecor: return .systemGreen
        case .electronics: return .systemPurple
        case .furniture: return .systemOrange
        case .fashion: return .systemPink
        case .books: return .systemYellow
        case .mobile: return .systemTeal
        case .other: return .darkGray
        }
    }
}
