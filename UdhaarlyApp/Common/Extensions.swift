//
//  Extensions.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 23/02/2026.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIView {
    func addDropShadow(color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 4, offset: CGSize = CGSize(width: 0, height: 2)) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }

    func applyThemeGradient() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 108/255, green: 92/255, blue: 231/255, alpha: 0.15).cgColor, // Soft Purple
            UIColor(red: 255/255, green: 126/255, blue: 95/255, alpha: 0.1).cgColor,  // Soft Peach
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0.0, 0.4, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}
extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

// MARK: - Standardized App Locations
struct AppLocations {
    static let lahoreLocations: [String] = [
        "DHA, Lahore",
        "Gulberg, Lahore",
        "Johar Town, Lahore",
        "Model Town, Lahore",
        "Bahria Town, Lahore",
        "Wapda Town, Lahore",
        "Township, Lahore",
        "Garden Town, Lahore",
        "Faisal Town, Lahore",
        "Valencia Town, Lahore",
        "Lake City, Lahore",
        "Cantt, Lahore",
        "Askari, Lahore",
        "Allama Iqbal Town, Lahore",
        "Gulshan-e-Ravi, Lahore",
        "Samanabad, Lahore",
        "Sabzazar, Lahore",
        "Shadman, Lahore",
        "Muslim Town, Lahore",
        "Ichhra, Lahore",
        "Mughalpura, Lahore",
        "Harbanspura, Lahore",
        "Baghbanpura, Lahore",
        "Shahdara, Lahore",
        "Green Town, Lahore",
        "Kot Lakhpat, Lahore",
        "Tajpura, Lahore",
        "Garhi Shahu, Lahore",
        "Anarkali, Lahore",
        "Mozang, Lahore",
        "Raiwind Road, Lahore",
        "Thokar Niaz Baig, Lahore",
        "Peco Road, Lahore",
        "Bedian Road, Lahore",
        "Canal Road, Lahore"
    ]
    
    static let karachiLocations: [String] = [
        "Clifton, Karachi",
        "Defence (DHA), Karachi",
        "Gulshan-e-Iqbal, Karachi",
        "PECHS, Karachi",
        "North Nazimabad, Karachi",
        "Gulistan-e-Johar, Karachi",
        "Bahria Town, Karachi",
        "Tariq Road, Karachi",
        "Bahadurabad, Karachi",
        "Saddar, Karachi",
        "Malir Cantt, Karachi",
        "Korangi, Karachi",
        "Federal B Area, Karachi",
        "Nazimabad, Karachi",
        "Scheme 33, Karachi",
        "Shah Faisal Colony, Karachi",
        "Buffer Zone, Karachi",
        "Zamzama, Karachi",
        "Boat Basin, Karachi",
        "KDA Scheme 1, Karachi"
    ]
    
    static let islamabadLocations: [String] = [
        "Blue Area, Islamabad",
        "F-6, Islamabad",
        "F-7, Islamabad",
        "F-8, Islamabad",
        "F-10, Islamabad",
        "F-11, Islamabad",
        "G-6, Islamabad",
        "G-7, Islamabad",
        "G-8, Islamabad",
        "G-9, Islamabad",
        "G-10, Islamabad",
        "G-11, Islamabad",
        "G-13, Islamabad",
        "E-7, Islamabad",
        "E-11, Islamabad",
        "I-8, Islamabad",
        "I-9, Islamabad",
        "I-10, Islamabad",
        "DHA Phase 2, Islamabad",
        "Bahria Town, Islamabad",
        "Chak Shahzad, Islamabad",
        "Bani Gala, Islamabad",
        "Gulberg Greens, Islamabad",
        "Islamabad Club, Islamabad"
    ]
    
    static let multanLocations: [String] = [
        "Bosan Road, Multan",
        "Gulgasht Colony, Multan",
        "Cantt, Multan",
        "DHA, Multan",
        "Model Town, Multan",
        "New Multan, Multan",
        "Shah Rukn-e-Alam Colony, Multan",
        "Wapda Town, Multan",
        "Officers Colony, Multan",
        "Mumtazabad, Multan",
        "Northern Bypass, Multan",
        "Multan City, Multan",
        "Shamsabad, Multan",
        "Garden Town, Multan",
        "Royal Orchard, Multan"
    ]
    
    /// All locations grouped and listed across the 4 major cities
    static let allLocations: [String] = lahoreLocations + karachiLocations + islamabadLocations + multanLocations
}


