//
//  ChatDetailViewController.swift
//  UdhaarlyApp
//

import UIKit
import AVFoundation
import Photos

/// Manages the detail screen of a specific chat where users can send and view individual messages.
class ChatDetailViewController: UIViewController {

    /// The parent LocalChat UUID that holds the history. Passed from ChatsViewController.
    var chatId: UUID?
    /// Set to the opposing user's email to display in the central navigation bar.
    var otherParticipantEmail: String = ""
    /// The user object for the other participant, used to fetch their name and profile.
    private var otherUser: LocalUser?
    
    // MARK: - Data
    
    /// Groups of messages keyed by their calendar day (e.g. "Today", "Yesterday", "Apr 1, 2026")
    private var groupedMessages: [(dateLabel: String, messages: [LocalMessage])] = []
    
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
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .chatPeach
        tv.translatesAutoresizingMaskIntoConstraints = false
        // Interactively dismiss the keyboard if the user swipes down on the table view.
        tv.keyboardDismissMode = .interactive
        // Remove extra space above the first section header on iOS 15+
        if #available(iOS 15.0, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
    }()

    /// The bottom container holding the input view and send button.
    private let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F8F9FA")
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Write your message..."
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 15)
        tf.backgroundColor = .clear
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private lazy var photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .systemGray3
        button.addTarget(self, action: #selector(handlePhotoAttach), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        button.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .brandOrange
        button.layer.cornerRadius = 22
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
        
        // Fetch user details to show name instead of email
        otherUser = LocalDataManager.shared.fetchUser(email: otherParticipantEmail)
        if let user = otherUser {
            title = "\(user.firstName) \(user.lastName)"
        } else {
            title = otherParticipantEmail
        }

        setupNavigationBar()
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

    // MARK: - Navigation Setup
    
    private func setupNavigationBar() {
        // Custom Title View
        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 18
        profileImageView.backgroundColor = .systemGray5
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let user = otherUser, let data = user.profileImageData {
            profileImageView.image = UIImage(data: data)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .systemGray3
        }

        let statusDot = UIView()
        statusDot.backgroundColor = .indicatorGreen
        statusDot.layer.cornerRadius = 5
        statusDot.layer.borderWidth = 1.5
        statusDot.layer.borderColor = UIColor.white.cgColor
        statusDot.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = otherUser != nil ? "\(otherUser!.firstName) \(otherUser!.lastName)" : otherParticipantEmail
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = UIColor(hex: "#4A2E19")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let statusLabel = UILabel()
        statusLabel.text = "• Online now"
        statusLabel.font = .systemFont(ofSize: 12)
        statusLabel.textColor = .indicatorGreen
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        let labelStack = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 0
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        titleContainer.addSubview(profileImageView)
        titleContainer.addSubview(statusDot)
        titleContainer.addSubview(labelStack)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 36),
            profileImageView.heightAnchor.constraint(equalToConstant: 36),

            statusDot.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 2),
            statusDot.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -2),
            statusDot.widthAnchor.constraint(equalToConstant: 10),
            statusDot.heightAnchor.constraint(equalToConstant: 10),

            labelStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            labelStack.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            labelStack.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            
            // Add explicit size to ensure tap area is non-zero
            titleContainer.heightAnchor.constraint(equalToConstant: 44),
            titleContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])

        // Profile Navigation: Make titleContainer interactive
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewProfile))
        titleContainer.isUserInteractionEnabled = true
        titleContainer.addGestureRecognizer(tap)

        navigationItem.titleView = titleContainer

        // Right Bar Button: Just the phone icon
        let phoneButton = UIBarButtonItem(
            image: UIImage(systemName: "phone.fill"),
            style: .plain,
            target: self,
            action: #selector(handleCallUser)
        )
        
        phoneButton.tintColor = UIColor(hex: "#4A2E19")
        navigationItem.rightBarButtonItem = phoneButton
        
        // Left Bar Button (Back)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(hex: "#4A2E19")
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 20
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func handleCallUser() {
        guard let phoneNumber = otherUser?.phoneNumber, !phoneNumber.isEmpty else {
            showUnavailableAlert(message: "This user hasn't provided a phone number.")
            return
        }
        
        // Clean the phone number (remove spaces, etc.)
        let cleanNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(cleanNumber)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showUnavailableAlert(message: "Your device cannot make phone calls.")
            }
        }
    }

    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleViewProfile() {
        guard let user = otherUser else {
            // If user not found, try fetching again just in case
            if let fetchedUser = LocalDataManager.shared.fetchUser(email: otherParticipantEmail) {
                let vc = UserProfileViewController(user: fetchedUser)
                navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        let vc = UserProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(messageInputContainerView)
        
        messageInputContainerView.addSubview(inputContainer)
        inputContainer.addSubview(messageTextField)
        inputContainer.addSubview(photoButton)
        messageInputContainerView.addSubview(actionButton)

        bottomConstraint = messageInputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor),

            messageInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            messageInputContainerView.heightAnchor.constraint(equalToConstant: 70),

            // Input container (grey box)
            inputContainer.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant: 16),
            inputContainer.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -12),
            inputContainer.heightAnchor.constraint(equalToConstant: 44),

            // Text field inside container
            messageTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 12),
            messageTextField.trailingAnchor.constraint(equalTo: photoButton.leadingAnchor, constant: -8),
            messageTextField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),

            // Photo button inside container on the right
            photoButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -12),
            photoButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            photoButton.widthAnchor.constraint(equalToConstant: 24),
            photoButton.heightAnchor.constraint(equalToConstant: 24),

            // Main orange action button
            actionButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 44),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Data Actions

    @objc private func textFieldDidChange() {
        // No action needed for icon toggle since we removed audio, 
        // but we could hide/show the button if desired.
    }

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
        textFieldDidChange()
        fetchMessages()
    }

    /// Triggered when the camera button is tapped. Presents an action sheet to let the user choose Camera or Photo Library.
    @objc private func handlePhotoAttach() {
        let alert = UIAlertController(title: "Send a Photo", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.requestCameraPermissionThenPresent()
        })
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.requestPhotoLibraryPermissionThenPresent()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // Required for iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = photoButton
            popover.sourceRect = photoButton.bounds
        }

        present(alert, animated: true)
    }

    // MARK: - Permission Requests

    /// Explicitly requests camera permission, then opens the camera picker if granted.
    private func requestCameraPermissionThenPresent() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showUnavailableAlert(message: "Camera is not available on this device.")
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentImagePicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.presentImagePicker(sourceType: .camera)
                    } else {
                        self?.showPermissionDeniedAlert(for: "Camera")
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert(for: "Camera")
        @unknown default:
            break
        }
    }

    /// Explicitly requests photo library permission, then opens the picker if granted.
    private func requestPhotoLibraryPermissionThenPresent() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            presentImagePicker(sourceType: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.presentImagePicker(sourceType: .photoLibrary)
                    } else {
                        self?.showPermissionDeniedAlert(for: "Photo Library")
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert(for: "Photo Library")
        @unknown default:
            break
        }
    }

    private func showUnavailableAlert(message: String) {
        let alert = UIAlertController(title: "Unavailable", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showPermissionDeniedAlert(for source: String) {
        let alert = UIAlertController(
            title: "\(source) Access Denied",
            message: "Please allow \(source) access in Settings > Privacy to send photos.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    /// Launches the native image picker for the requested source (camera or library).
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }

    /// Retrieves all historical messages, marks incoming ones as read, and groups them by day.
    private func fetchMessages() {
        guard let id = chatId,
              let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") else { return }
        
        // Opening this chat means the current user has read all messages sent by the other person.
        LocalDataManager.shared.markMessagesAsRead(chatId: id, recipientEmail: currentEmail)
        
        let allMessages = LocalDataManager.shared.fetchMessages(forChatId: id)
        groupedMessages = groupByDate(allMessages)
        tableView.reloadData()
        scrollToBottom(animated: false)
    }

    /// Partitions a flat array of messages into day-labelled groups.
    /// - Parameter messages: The complete ordered list of messages.
    /// - Returns: An array of tuples with a human-readable date label and its messages.
    private func groupByDate(_ messages: [LocalMessage]) -> [(dateLabel: String, messages: [LocalMessage])] {
        let calendar = Calendar.current
        var groups: [(dateLabel: String, messages: [LocalMessage])] = []
        var currentLabel: String?
        var currentGroup: [LocalMessage] = []

        for message in messages {
            let label = dateLabel(for: message.timestamp, calendar: calendar)

            if label == currentLabel {
                currentGroup.append(message)
            } else {
                if let existing = currentLabel {
                    groups.append((dateLabel: existing, messages: currentGroup))
                }
                currentLabel = label
                currentGroup = [message]
            }
        }

        // Flush last group
        if let remaining = currentLabel, !currentGroup.isEmpty {
            groups.append((dateLabel: remaining, messages: currentGroup))
        }

        return groups
    }

    /// Produces a human-readable label for a date: "Today", "Yesterday", or "MMM d, yyyy".
    private func dateLabel(for date: Date, calendar: Calendar) -> String {
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }

    private func scrollToBottom(animated: Bool) {
        guard !groupedMessages.isEmpty else { return }
        let lastSection = groupedMessages.count - 1
        let lastRow = groupedMessages[lastSection].messages.count - 1
        guard lastRow >= 0 else { return }
        let indexPath = IndexPath(row: lastRow, section: lastSection)
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

    /// Triggered natively when the virtual keyboard shuts. Restores UI height downwards smoothly.
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

// MARK: - UITableViewDelegate & DataSource

extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedMessages.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMessages[section].messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let message = groupedMessages[indexPath.section].messages[indexPath.row]
        let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") ?? ""
        cell.configure(with: message, currentEmail: currentEmail)
        cell.delegate = self
        return cell
    }

    /// Renders the sticky "Today / Yesterday / Apr 1, 2026" date divider between message groups.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = groupedMessages[section].dateLabel.uppercased()

        // Use custom peach background
        let containerView = UIView()
        containerView.backgroundColor = .chatPeach

        let capsule = UILabel()
        capsule.font = .systemFont(ofSize: 11, weight: .bold)
        capsule.textColor = .brandOrange
        capsule.backgroundColor = .dateHeaderPeach
        capsule.textAlignment = .center
        capsule.clipsToBounds = true
        capsule.layer.cornerRadius = 6
        capsule.translatesAutoresizingMaskIntoConstraints = false
        // Horizontal padding via leading/trailing spaces
        capsule.text = "   \(label)   "

        containerView.addSubview(capsule)
        NSLayoutConstraint.activate([
            capsule.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            capsule.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            capsule.heightAnchor.constraint(equalToConstant: 22),
            capsule.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            capsule.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            capsule.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
        ])

        return containerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ChatDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage,
              let id = chatId,
              let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail"),
              // Compress to reasonable JPEG quality to keep storage manageable
              let imageData = image.jpegData(compressionQuality: 0.7) else {
            return
        }

        // Send the photo as a standalone message with empty text content
        LocalDataManager.shared.sendMessage(chatId: id, senderEmail: currentEmail, content: "", imageData: imageData)
        fetchMessages()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - MessageCellDelegate

extension ChatDetailViewController: MessageCellDelegate {
    func messageCell(_ cell: MessageCell, didTapImage image: UIImage) {
        let vc = FullscreenImageViewController(image: image)
        present(vc, animated: true)
    }
}
