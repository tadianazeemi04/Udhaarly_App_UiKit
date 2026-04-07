//
//  ReviewInputViewController.swift
//  UdhaarlyApp
//
//  Created by Udhaarly Assistant on 06/03/2026.
//

import UIKit

class ReviewInputViewController: UIViewController {

    // MARK: - Properties
    var revieweeEmail: String
    var revieweeName: String
    var requestId: UUID?
    var isLender: Bool = false
    private var selectedRating: Int = 0
    var onReviewSubmit: (() -> Void)?

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate your experience"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let starStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let reviewTitleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Review Title (Optional)"
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 16, weight: .medium)
        tf.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        tf.layer.cornerRadius = 12
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let reviewBodyTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit Review", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 15
        btn.addDropShadow(opacity: 0.2, radius: 8)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .systemGray4
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Initializer
    init(revieweeEmail: String, revieweeName: String, requestId: UUID? = nil, isLender: Bool = false) {
        self.revieweeEmail = revieweeEmail
        self.revieweeName = revieweeName
        self.requestId = requestId
        self.isLender = isLender
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        subtitleLabel.text = "How was your borrowing/lending with \(revieweeName)? Your feedback helps the community."
        setupUI()
        setupStars()
        setupActions()
    }

    private func setupUI() {
        view.addSubview(containerView)
        [titleLabel, subtitleLabel, starStackView, reviewTitleField, reviewBodyTextView, submitButton, closeButton].forEach { containerView.addSubview($0) }

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 500),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),

            starStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            starStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            starStackView.widthAnchor.constraint(equalToConstant: 250),
            starStackView.heightAnchor.constraint(equalToConstant: 44),

            reviewTitleField.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 30),
            reviewTitleField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            reviewTitleField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            reviewTitleField.heightAnchor.constraint(equalToConstant: 50),

            reviewBodyTextView.topAnchor.constraint(equalTo: reviewTitleField.bottomAnchor, constant: 15),
            reviewBodyTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            reviewBodyTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            reviewBodyTextView.heightAnchor.constraint(equalToConstant: 100),

            submitButton.topAnchor.constraint(equalTo: reviewBodyTextView.bottomAnchor, constant: 25),
            submitButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            submitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            submitButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    private func setupStars() {
        for i in 1...5 {
            let btn = UIButton()
            btn.tag = i
            btn.setImage(UIImage(systemName: "star"), for: .normal)
            btn.tintColor = .systemGray4
            btn.contentVerticalAlignment = .fill
            btn.contentHorizontalAlignment = .fill
            btn.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starStackView.addArrangedSubview(btn)
        }
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }

    @objc private func starTapped(_ sender: UIButton) {
        selectedRating = sender.tag
        
        // Impact Feedback for a premium feel
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        for (index, view) in starStackView.arrangedSubviews.enumerated() {
            if let starBtn = view as? UIButton {
                let isSelected = index < selectedRating
                starBtn.setImage(UIImage(systemName: isSelected ? "star.fill" : "star"), for: .normal)
                starBtn.tintColor = isSelected ? .systemYellow : .systemGray4
                
                // Pop animation
                UIView.animate(withDuration: 0.1, animations: {
                    starBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { _ in
                    UIView.animate(withDuration: 0.1) {
                        starBtn.transform = .identity
                    }
                }
            }
        }
    }

    @objc private func handleSubmit() {
        guard selectedRating > 0 else {
            let alert = UIAlertController(title: "Rating Required", message: "Please select a star rating before submitting.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        
        // Fetch current user's name from database, fallback to saved name or default
        let user = LocalDataManager.shared.fetchUser(email: currentUserEmail)
        let currentUserName = user != nil ? "\(user!.firstName) \(user!.lastName)" : (UserDefaults.standard.string(forKey: "currentUserName") ?? "Anonymous Neighbor")

        let review = LocalReview(
            reviewerName: currentUserName,
            reviewerEmail: currentUserEmail,
            revieweeEmail: revieweeEmail,
            rating: selectedRating,
            title: reviewTitleField.text ?? "",
            body: reviewBodyTextView.text ?? ""
        )

        LocalDataManager.shared.saveReview(review: review)
        
        // Mark request as reviewed so the 'Rate' button disappears
        if let requestId = requestId {
            LocalDataManager.shared.markRequestAsReviewed(requestId: requestId, isLender: isLender)
        }
        
        // Show success and dismiss
        let alert = UIAlertController(title: "Success", message: "Thank you for your feedback!", preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true) {
                self.onReviewSubmit?()
                self.dismiss(animated: true)
            }
        }
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
