//
//  Views.swift
//  UdhaarlyApp
//
//  Created by Antigravity on 09/03/2026.
//

import UIKit

/// A custom UIView that renders a linear gradient background.
/// This is used for main form containers to give them a premium, depth-rich look.
class GradientCardView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 254/255, green: 243/255, blue: 239/255, alpha: 1.0).cgColor,
            UIColor(red: 255/255, green: 252/255, blue: 252/255, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.87]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the gradient layer matches the view's current bounds and corner radius
        // during layout changes (e.g. device rotation or dynamic resizing).
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
}
