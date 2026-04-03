//
//  MessageCell.swift
//  UdhaarlyApp
//

import UIKit

protocol MessageCellDelegate: AnyObject {
    func messageCell(_ cell: MessageCell, didTapImage image: UIImage)
}

class MessageCell: UITableViewCell {

    static let identifier = "MessageCell"

    // MARK: - UI Components

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Displays image content inside the bubble for photo messages.
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Shows read-receipt ticks (✓ sent, ✓✓ delivered, ✓✓ read) only for outgoing messages.
    private let receiptLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    weak var delegate: MessageCellDelegate?

    // MARK: - Layout Constraints

    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var timeLeadingConstraint: NSLayoutConstraint!
    private var timeTrailingConstraint: NSLayoutConstraint!

    // Constraints toggled based on message type
    private var textPaddingConstraints: [NSLayoutConstraint] = []
    private var imageSizeConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(receiptLabel)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(photoImageView)

        // Bubble alignment
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        // Standard margin for outgoing bubbles
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        // Time label alignment mirrors bubble
        timeLeadingConstraint = timeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor)
        timeTrailingConstraint = timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor)

        // Text message: label fills the bubble with padding
        textPaddingConstraints = [
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16),
        ]

        // Photo message: image fills the bubble edge-to-edge
        imageSizeConstraints = [
            photoImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 200),
            photoImageView.heightAnchor.constraint(equalToConstant: 200),
        ]

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            // Shared bottom alignment for time and receipt
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            receiptLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            
            // Positioning for outgoing messages: [Time] [Ticks] (Aligned to bubble right)
            receiptLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: receiptLabel.leadingAnchor, constant: -4),
            
            // Positioning for incoming messages: [Time] (Aligned to bubble left)
            timeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
        ])
        
        // Deactivate the dynamic time constraints we setup earlier as we're using a more static approach now
        timeLeadingConstraint.isActive = false
        timeTrailingConstraint.isActive = false

        setupGestures()
    }

    private func setupGestures() {
        photoImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTap))
        photoImageView.addGestureRecognizer(tap)
    }

    @objc private func handlePhotoTap() {
        guard let image = photoImageView.image else { return }
        delegate?.messageCell(self, didTapImage: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with message: LocalMessage, currentEmail: String) {
        let isCurrentUser = message.senderEmail == currentEmail

        // Time label
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: message.timestamp)

        // Determine alignment and apply bubble "tails"
        // Determine alignment and apply bubble "tails"
        if isCurrentUser {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
            bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }

        // Photo message
        if let data = message.imageData, let image = UIImage(data: data) {
            photoImageView.image = image
            photoImageView.isHidden = false
            messageLabel.isHidden = true
            bubbleView.backgroundColor = .clear

            NSLayoutConstraint.deactivate(textPaddingConstraints)
            NSLayoutConstraint.activate(imageSizeConstraints)
            
            if isCurrentUser {
                bubbleView.layer.borderWidth = 4
                bubbleView.layer.borderColor = UIColor(hex: "#FF8C42").cgColor
            } else {
                bubbleView.layer.borderWidth = 0
            }
        } else {
            // Text message
            photoImageView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = message.content

            NSLayoutConstraint.deactivate(imageSizeConstraints)
            NSLayoutConstraint.activate(textPaddingConstraints)

            if isCurrentUser {
                bubbleView.backgroundColor = UIColor(hex: "#FF8C42") // Vibrant Orange
                messageLabel.textColor = .white
                bubbleView.layer.borderWidth = 0
            } else {
                bubbleView.backgroundColor = .incomingBubble
                messageLabel.textColor = UIColor(hex: "#5A3E2B") // Dark Brown
                bubbleView.layer.borderWidth = 0
            }
        }

        // Read receipt ticks — only shown on outgoing (sender's) messages
        if isCurrentUser {
            receiptLabel.isHidden = false
            // Ensure time label is pinned to the left of the receipt
            timeLabel.isHidden = false 
            if message.isRead {
                // Double tick in brand orange — other user has read the message
                receiptLabel.text = "✓✓"
                receiptLabel.textColor = .brandOrange
            } else if message.isDelivered {
                // Double tick in gray — other user's inbox received it
                receiptLabel.text = "✓✓"
                receiptLabel.textColor = .lightGray
            } else {
                // Single tick in gray — sent but not yet delivered
                receiptLabel.text = "✓"
                receiptLabel.textColor = .lightGray
            }
        } else {
            receiptLabel.isHidden = true
        }
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoImageView.isHidden = true
        messageLabel.isHidden = false
        messageLabel.text = nil
        bubbleView.backgroundColor = nil
        receiptLabel.isHidden = true
        receiptLabel.text = nil
        NSLayoutConstraint.deactivate(imageSizeConstraints)
        NSLayoutConstraint.deactivate(textPaddingConstraints)
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
        timeLeadingConstraint.isActive = false
        timeTrailingConstraint.isActive = false
    }
}
