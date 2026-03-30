//
//  NotificationsViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 27/03/2026.
//

import UIKit

/// NotificationsViewController displays a chronological list of user alerts.
class NotificationsViewController: UIViewController {

    // MARK: - Properties
    
    /// Local storage for the list of notifications retrieved from the database.
    private var notifications: [LocalNotification] = []
    
    // MARK: - UI Components
    
    /// The screen's header label.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .brandOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Back button to return to the dashboard.
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    /// The table view displaying notification rows.
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    /// Placeholder shown when the user has no notifications.
    private let emptyView: UIStackView = {
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor.brandOrange.withAlphaComponent(0.1)
        iconContainer.layer.cornerRadius = 40
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iconContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let icon = UIImageView(image: UIImage(systemName: "bell.and.waves.left.and.right.fill"))
        icon.tintColor = .brandOrange
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let label = UILabel()
        label.text = "All caught up!"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        let subLabel = UILabel()
        subLabel.text = "Your notification inbox is empty.\nWe'll let you know when something happens."
        subLabel.textColor = .gray
        subLabel.font = .systemFont(ofSize: 14)
        subLabel.numberOfLines = 0
        subLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [iconContainer, label, subLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    /// A "Clear All" button located in the header.
    private let clearAllButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Clear All", for: .normal)
        btn.setTitleColor(.brandOrange, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        fetchNotifications()
        markAllAsRead()
        
        /// Update the Dashboard badge once after initial load.
        NotificationCenter.default.post(name: .didReceiveNewNotification, object: nil)
        
        /// Subscribe to internal notifications for real-time list updates.
        /// Adding this AFTER the initial setup prevents unwanted self-triggering at launch.
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewNotification), name: .didReceiveNewNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// Clean up observers to prevent memory leaks.
        NotificationCenter.default.removeObserver(self, name: .didReceiveNewNotification, object: nil)
    }
    
    // MARK: - Setup
    
    /// Configures the visual layout and constraints.
    private func setupLayout() {
        /// Use a slightly shaded background for better card contrast.
        view.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(clearAllButton)
        view.addSubview(tableView)
        view.addSubview(emptyView)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        clearAllButton.addTarget(self, action: #selector(didTapClearAll), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clearAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            clearAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Data Logic
    
    /// Loads notifications for the current user from SwiftData.
    private func fetchNotifications() {
        /// Standardized key 'currentUserEmail' used for all account-related data.
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        notifications = LocalDataManager.shared.fetchNotifications(forEmail: email)
        
        tableView.reloadData()
        emptyView.isHidden = !notifications.isEmpty
    }
    
    /// Marks all unread items as read upon opening the screen.
    private func markAllAsRead() {
        /// Standardized key 'currentUserEmail' used for all account-related data.
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        LocalDataManager.shared.markAllNotificationsAsRead(forEmail: email)
        /// NOTE: Removed NotificationCenter.post from here to prevent infinite recursion loop
        /// with handleNewNotification() which is triggered by this same broadcast.
    }
    
    /// Clears all notifications for the current user after confirmation.
    @objc private func didTapClearAll() {
        guard !notifications.isEmpty else { return }
        
        let alert = UIAlertController(title: "Clear Notifications?", message: "This will permanently delete all your notifications.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear All", style: .destructive, handler: { [weak self] _ in
            guard let self = self, let email = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
            
            /// Remove each notification from persistence.
            for notification in self.notifications {
                LocalDataManager.shared.deleteNotification(notification: notification)
            }
            
            /// Update local state and UI.
            self.notifications.removeAll()
            self.tableView.reloadData()
            self.emptyView.isHidden = false
            
            /// Notify the badge on Dashboard to clear.
            NotificationCenter.default.post(name: .didReceiveNewNotification, object: nil)
        }))
        
        present(alert, animated: true)
    }
    
    /// Returns the user to the previous screen.
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Triggered when a new notification is received while the view is active.
    @objc private func handleNewNotification() {
        fetchNotifications()
        markAllAsRead() // Auto-mark as read since the user is on this screen.
    }
}

// MARK: - UITableView Delegate & DataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row]
        cell.configure(with: notification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Enables swipe-to-delete functionality for single notifications.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notification = notifications[indexPath.row]
            LocalDataManager.shared.deleteNotification(notification: notification)
            notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            emptyView.isHidden = !notifications.isEmpty
        }
    }
}

// MARK: - NotificationCell

/// A custom cell designed to display notification details in a premium card format.
class NotificationCell: UITableViewCell {
    
    /// Container for the cell content with shadow and rounded corners.
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.addDropShadow(opacity: 0.08, radius: 8, offset: CGSize(width: 0, height: 4))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A thin colored indicator on the left side of the card.
    private let typeIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Icon representing the notification type.
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    /// The notification's headline.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The notification's descriptive message.
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Relative time string (e.g., "5m ago").
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Red dot indicator for unread notifications.
    private let unreadDot: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 4
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Builds the cell hierarchy and sets constraints.
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(typeIndicator)
        containerView.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(unreadDot)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            typeIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            typeIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            typeIndicator.widthAnchor.constraint(equalToConstant: 4),
            typeIndicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            
            iconContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            iconContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: unreadDot.leadingAnchor, constant: -8),
            
            unreadDot.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            unreadDot.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            unreadDot.widthAnchor.constraint(equalToConstant: 8),
            unreadDot.heightAnchor.constraint(equalToConstant: 8),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bodyLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            bodyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
    }
    
    /// Populates the UI elements with data from a LocalNotification object.
    /// - Parameter notification: The data model to display.
    func configure(with notification: LocalNotification) {
        titleLabel.text = notification.title
        bodyLabel.text = notification.body
        timeLabel.text = notification.createdAt.timeAgoDisplay().uppercased()
        unreadDot.isHidden = notification.isRead
        
        /// Highlight the card based on status.
        containerView.backgroundColor = notification.isRead ? .white : UIColor.brandOrange.withAlphaComponent(0.02)
        
        /// Select an appropriate theme and icon based on the notification type.
        switch notification.type {
        case "request":
            iconView.image = UIImage(systemName: "hand.raised.fill")
            iconView.tintColor = .brandOrange
            iconContainer.backgroundColor = UIColor.brandOrange.withAlphaComponent(0.1)
            typeIndicator.backgroundColor = .brandOrange
        case "chat":
            iconView.image = UIImage(systemName: "message.fill")
            iconView.tintColor = .systemBlue
            iconContainer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            typeIndicator.backgroundColor = .systemBlue
        default:
            iconView.image = UIImage(systemName: "info.circle.fill")
            iconView.tintColor = .systemIndigo
            iconContainer.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.1)
            typeIndicator.backgroundColor = .systemIndigo
        }
        
        /// Soften the UI for already read notifications.
        containerView.alpha = notification.isRead ? 0.8 : 1.0
    }
}

/// Helper extension for relative time formatting.
extension Date {
    /// Returns a human-readable relative time string.
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
