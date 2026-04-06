//
//  ReviewCell.swift
//  UdhaarlyApp
//

import UIKit

class ReviewCell: UITableViewCell {
    static let identifier = "ReviewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#F1F5F9").cgColor
        view.addDropShadow(color: .black, opacity: 0.05, radius: 10, offset: CGSize(width: 0, height: 4))
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let reviewerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        iv.image = UIImage(named: "avatar_placeholder")
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let reviewerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        [titleLabel, ratingStack, bodyLabel, reviewerImageView, reviewerNameLabel, dateLabel].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            
            ratingStack.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ratingStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            reviewerImageView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            reviewerImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            reviewerImageView.widthAnchor.constraint(equalToConstant: 30),
            reviewerImageView.heightAnchor.constraint(equalToConstant: 30),
            reviewerImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            
            reviewerNameLabel.topAnchor.constraint(equalTo: reviewerImageView.topAnchor, constant: -2),
            reviewerNameLabel.leadingAnchor.constraint(equalTo: reviewerImageView.trailingAnchor, constant: 8),
            
            dateLabel.topAnchor.constraint(equalTo: reviewerNameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: reviewerNameLabel.leadingAnchor)
        ])
    }
    
    func configure(with review: LocalReview) {
        titleLabel.text = review.title
        bodyLabel.text = review.body
        
        // Fetch real user data if available
        if let user = LocalDataManager.shared.fetchUser(email: review.reviewerEmail) {
            reviewerNameLabel.text = "\(user.firstName) \(user.lastName)"
            if let imageData = user.profileImageData {
                reviewerImageView.image = UIImage(data: imageData)
            } else {
                reviewerImageView.image = UIImage(systemName: "person.circle.fill")
                reviewerImageView.tintColor = .systemGray3
            }
        } else {
            // Fallback to name stored in review (for dummy data)
            reviewerNameLabel.text = review.reviewerName
            reviewerImageView.image = UIImage(systemName: "person.circle.fill")
            reviewerImageView.tintColor = .systemGray3
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        dateLabel.text = formatter.string(from: review.createdAt)
        
        // Setup Stars
        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 1...5 {
            let iv = UIImageView()
            iv.image = UIImage(systemName: i <= review.rating ? "star.fill" : "star")
            iv.tintColor = .systemYellow
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.widthAnchor.constraint(equalToConstant: 14).isActive = true
            iv.heightAnchor.constraint(equalToConstant: 14).isActive = true
            ratingStack.addArrangedSubview(iv)
        }
    }
}
