//
//  ChatsViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 11/03/2026.
//

import UIKit

/// This controller manages the Inbox screen displaying a list of all active conversations.
class ChatsViewController: UIViewController {

    /// Holds the list of conversations fetched from SwiftData.
    private var chats: [LocalChat] = []

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chats"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .brandOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // Empty State Components
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let emptyStateIcon: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        iv.image = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: config)
        iv.tintColor = .brandOrange.withAlphaComponent(0.6)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let emptyStateTitle: UILabel = {
        let label = UILabel()
        label.text = "No Conversations Yet"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateSubtitle: UILabel = {
        let label = UILabel()
        label.text = "When you reach out to a lender or receive borrow inquiries, your chat messages will appear here."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the global navigation bar doesn't interfere with our custom title label
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Refresh chats every time the view is about to appear to ensure we have the latest
        fetchChats()
    }
    
    /// Queries the LocalDataManager for all active chat threads that the current user is a part of.
    private func fetchChats() {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") else { return }
        // Simulate delivery: the current user opening their inbox means messages sent TO them are now delivered.
        LocalDataManager.shared.markMessagesAsDelivered(for: currentEmail)
        self.chats = LocalDataManager.shared.fetchChats(forEmail: currentEmail)
        
        let isEmpty = self.chats.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        tableView.reloadData()
    }

    // MARK: - Setup
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        emptyStateView.addSubview(emptyStateIcon)
        emptyStateView.addSubview(emptyStateTitle)
        emptyStateView.addSubview(emptyStateSubtitle)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State Constraints
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emptyStateIcon.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateIcon.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateIcon.widthAnchor.constraint(equalToConstant: 70),
            emptyStateIcon.heightAnchor.constraint(equalToConstant: 60),
            
            emptyStateTitle.topAnchor.constraint(equalTo: emptyStateIcon.bottomAnchor, constant: 16),
            emptyStateTitle.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateTitle.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            emptyStateSubtitle.topAnchor.constraint(equalTo: emptyStateTitle.bottomAnchor, constant: 8),
            emptyStateSubtitle.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateSubtitle.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateSubtitle.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
}

// MARK: - Table View Handling
extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        let chat = chats[indexPath.row]
        let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") ?? ""
        
        // Determine the opposing participant's email to display their name instead of our own.
        let otherParticipantEmail = (chat.participant1Email == currentEmail) ? chat.participant2Email : chat.participant1Email
        
        var displayName = otherParticipantEmail
        var profileImage: Data? = nil
        
        if let user = LocalDataManager.shared.fetchUser(email: otherParticipantEmail) {
            displayName = "\(user.firstName) \(user.lastName)"
            profileImage = user.profileImageData
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let timeString = dateFormatter.string(from: chat.lastUpdated)
        let messageText = chat.lastMessage ?? "Start a conversation"
        
        cell.configure(name: displayName, message: messageText, time: timeString, badgeCount: 0, profileImage: profileImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        let detailVC = ChatDetailViewController()
        
        // Pass the unique chat id to the detail view controller so it loads the correct messages string
        detailVC.chatId = chat.id
        
        let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") ?? ""
        detailVC.otherParticipantEmail = (chat.participant1Email == currentEmail) ? chat.participant2Email : chat.participant1Email
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
