//
//  ChatDetailViewController.swift
//  UdhaarlyApp
//

import UIKit

/// Manages the detail screen of a specific chat where users can send and view individual messages.
class ChatDetailViewController: UIViewController {

    /// The parent LocalChat UUID that holds the history. Passed from ChatsViewController.
    var chatId: UUID?
    /// Set to the opposing user's email to display in the central navigation bar.
    var otherParticipantEmail: String = ""
    /// Currently loaded messages connected to this chat.
    private var messages: [LocalMessage] = []
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // Ensure the main tab bar is hidden to maximize vertical space for chatting
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components
    
    /// The main scrolling display for chat bubbles.
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        // Interactively dismiss the keyboard if the user swipes down on the table view.
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    /// The bottom container holding the input view and send button.
    private let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type a message..."
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .brandOrange
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// We keep a reference to this layout constraint so we can push it up when the keyboard appears.
    private var bottomConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = otherParticipantEmail
        
        setupLayout()
        fetchMessages()
        
        // Listen to native iOS keyboard events so the bottom container can move accordingly.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reveal navigation bar since the previous view (Chats Inbox) had it hidden.
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Layout Setup
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(messageInputContainerView)
        messageInputContainerView.addSubview(messageTextField)
        messageInputContainerView.addSubview(sendButton)
        
        // Pins the input view to the bottom safe area so it spans properly on devices lacking/having home-bars.
        bottomConstraint = messageInputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor),
            
            messageInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            messageInputContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            messageTextField.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant: 16),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - User Output Actions
    
    /// Triggered when the send button is tapped, parses input and interacts with the Data Manager.
    @objc private func handleSend() {
        // Ensure the textbox actually has written text instead of whitespace, and grab parameters.
        guard let text = messageTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty,
              let id = chatId,
              let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") else {
            return
        }
        
        // Send actual text content to local persistence
        LocalDataManager.shared.sendMessage(chatId: id, senderEmail: currentEmail, content: text)
        // Reset the textview since operation succeeded
        messageTextField.text = ""
        fetchMessages()
    }
    
    /// Retrieves all historical messages to sync the internal array.
    private func fetchMessages() {
        guard let id = chatId else { return }
        messages = LocalDataManager.shared.fetchMessages(forChatId: id)
        tableView.reloadData()
        // Ensure user sees the most recently sent message.
        scrollToBottom(animated: false)
    }
    
    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    // MARK: - Keyboard Event Handling
    
    /// Triggered natively when the virtual keyboard pops out. Shifts UI container constraint dynamically by keyboard's computed height.
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let safeAreaBottom = view.safeAreaInsets.bottom
            bottomConstraint.constant = -(keyboardFrame.height - safeAreaBottom)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.scrollToBottom(animated: true)
            }
        }
    }
    
    /// Triggered natively when the virtual keyboard shuts. Restores UI height down downwards smoothly.
    @objc private func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Data Source Delegate Methods
extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        
        let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") ?? ""
        // Have the cell apply right/left stylings based on whether we sent it or received it.
        cell.configure(with: message, currentEmail: currentEmail)
        return cell
    }
}
