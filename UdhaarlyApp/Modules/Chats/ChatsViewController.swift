//
//  ChatsViewController.swift
//  UdhaarlyApp
//
//  Created by Antigravity on 11/03/2026.
//

import UIKit

class ChatsViewController: UIViewController {

    // MARK: - Data Mockup
    private struct ChatHistory {
        let name: String
        let message: String
        let time: String
        let unreadCount: Int
    }

    private let chatHistory: [ChatHistory] = [
        ChatHistory(name: "Ahmad Bashir", message: "Hey is this available in other flavor", time: "11:38 AM", unreadCount: 3),
        ChatHistory(name: "Ahmad Bashir", message: "Hey is this available in other flavor", time: "11:38 AM", unreadCount: 3),
        ChatHistory(name: "Ahmad Bashir", message: "Hey is this available in other flavor", time: "11:38 AM", unreadCount: 3),
        ChatHistory(name: "Ahmad Bashir", message: "Hey is this available in other flavor", time: "11:38 AM", unreadCount: 3),
        ChatHistory(name: "Ahmad Bashir", message: "Hey is this available in other flavor", time: "11:38 AM", unreadCount: 3),
        ChatHistory(name: "Ahmad Bashir", message: "Hey is this available in other flavor", time: "11:38 AM", unreadCount: 3)
    ]

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        let chat = chatHistory[indexPath.row]
        cell.configure(name: chat.name, message: chat.message, time: chat.time, badgeCount: chat.unreadCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
