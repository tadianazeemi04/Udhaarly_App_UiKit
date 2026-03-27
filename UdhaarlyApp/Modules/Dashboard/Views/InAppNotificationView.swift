//
//  InAppNotificationView.swift
//  UdhaarlyApp
//
//  Created by Antigravity on 27/03/2026.
//

import UIKit

/// InAppNotificationView is a premium, top-down animated banner for real-time alerts.
class InAppNotificationView: UIView {
    
    // MARK: - UI Components
    
    /// Main rounded container for the banner.
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.addDropShadow(opacity: 0.2, radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Headline of the banner.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Descriptive text of the banner.
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Aesthetic accent bar on the left side of the banner.
    private let accentBar: UIView = {
        let view = UIView()
        view.backgroundColor = .brandOrange
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    /// Creates a new banner instance.
    /// - Parameters:
    ///   - title: Bold headline text.
    ///   - body: Verbose message text.
    init(title: String, body: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        bodyLabel.text = body
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    /// Builds the visual hierarchy and anchors.
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(accentBar)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            accentBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            accentBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            accentBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            accentBar.widthAnchor.constraint(equalToConstant: 4),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Animation
    
    /// Static presentation method to handle the slide-down animation and auto-dismissal.
    /// - Parameters:
    ///   - title: Alert title.
    ///   - body: Alert message.
    static func show(title: String, body: String) {
        /// Retrieve the active window safely using modern scene APIs.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let banner = InAppNotificationView(title: title, body: body)
        banner.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(banner)
        
        /// Calculate safe area top to prevent overlap with Notch/Dynamic Island.
        let topPadding = window.safeAreaInsets.top
        
        /// Set initial position off-screen (above the visible top edge).
        let topConstraint = banner.topAnchor.constraint(equalTo: window.topAnchor, constant: -100)
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            topConstraint
        ])
        
        window.layoutIfNeeded()
        
        /// Phase 1: Slide down into view.
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            topConstraint.constant = topPadding + 10
            window.layoutIfNeeded()
        }) { _ in
            /// Phase 2: Slide back up and remove after 3 seconds.
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseIn, animations: {
                topConstraint.constant = -150
                window.layoutIfNeeded()
            }) { _ in
                banner.removeFromSuperview()
            }
        }
    }
}
