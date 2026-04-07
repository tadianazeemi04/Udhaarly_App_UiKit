import UIKit

class RequestCardView: UIView {
    
    var onAccept: (() -> Void)?
    var onCancel: (() -> Void)?
    var onChat: (() -> Void)?
    var onReturn: (() -> Void)?
    var onDelay: (() -> Void)?
    var onConfirmReturn: (() -> Void)?
    var onViewReturnDetails: (() -> Void)?
    var onRateUser: (() -> Void)?
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let productImgView = UIImageView()
    private let prodTitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let durationLabel = UILabel()
    private let availableAgainLabel = UILabel()
    private let actionStack = UIStackView()
    
    init(request: LocalRequest, isLender: Bool) {
        super.init(frame: .zero)
        setupUI(isLender: isLender)
        configure(with: request, isLender: isLender)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI(isLender: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        addDropShadow(opacity: 0.05, radius: 8, offset: CGSize(width: 0, height: 4))
        
        // --- Top Profile Section ---
        profileImageView.backgroundColor = UIColor(hex: "#D9D9D9")
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        let phoneIcon = UIImageView(image: UIImage(systemName: "phone.fill"))
        phoneIcon.tintColor = .black
        phoneIcon.contentMode = .scaleAspectFit
        
        phoneLabel.font = .systemFont(ofSize: 12)
        
        let eyeSlash = UIImageView(image: UIImage(systemName: "eye.slash"))
        eyeSlash.tintColor = .black
        eyeSlash.contentMode = .scaleAspectFit
        
        let topStack = UIStackView(arrangedSubviews: [profileImageView, nameLabel, UIView(), phoneIcon, phoneLabel, eyeSlash])
        topStack.axis = .horizontal
        topStack.spacing = 8
        topStack.alignment = .center
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
        // --- Separator ---
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0, alpha: 0.1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        // --- Product Section ---
        productImgView.backgroundColor = UIColor(hex: "#565656")
        productImgView.layer.cornerRadius = 8
        productImgView.clipsToBounds = true
        productImgView.contentMode = .scaleAspectFill
        productImgView.translatesAutoresizingMaskIntoConstraints = false
        
        prodTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        prodTitleLabel.numberOfLines = 2
        
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        durationLabel.font = .systemFont(ofSize: 10)
        durationLabel.textColor = .gray
        
        availableAgainLabel.font = .systemFont(ofSize: 12, weight: .bold)
        availableAgainLabel.textColor = .systemGreen
        availableAgainLabel.textAlignment = .center
        availableAgainLabel.isHidden = true
        
        let detailStack = UIStackView(arrangedSubviews: [prodTitleLabel, priceLabel, durationLabel, availableAgainLabel])
        detailStack.axis = .vertical
        detailStack.spacing = 2
        
        let productStack = UIStackView(arrangedSubviews: [productImgView, detailStack])
        productStack.axis = .horizontal
        productStack.spacing = 12
        productStack.alignment = .top
        productStack.translatesAutoresizingMaskIntoConstraints = false
        
        // --- Actions Section ---
        actionStack.axis = .horizontal
        actionStack.spacing = 12
        actionStack.distribution = .fillEqually
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topStack)
        addSubview(separator)
        addSubview(productStack)
        addSubview(actionStack)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            
            productImgView.widthAnchor.constraint(equalToConstant: 80),
            productImgView.heightAnchor.constraint(equalToConstant: 60),
            
            topStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            topStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            topStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            separator.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            productStack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12),
            productStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            productStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            actionStack.topAnchor.constraint(equalTo: productStack.bottomAnchor, constant: 15),
            actionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            actionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            actionStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            actionStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            
            eyeSlash.widthAnchor.constraint(equalToConstant: 18),
            phoneIcon.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    private func configure(with request: LocalRequest, isLender: Bool) {
        let otherUserEmail = isLender ? request.borrowerEmail : request.lenderEmail
        let otherUser = LocalDataManager.shared.fetchUser(email: otherUserEmail)
        let product = LocalDataManager.shared.fetchProduct(id: request.productId)
        
        nameLabel.text = otherUser != nil ? "\(otherUser!.firstName) \(otherUser!.lastName)" : "Udhaarly User"
        phoneLabel.text = otherUser?.phoneNumber ?? "N/A"
        
        if let profileData = otherUser?.profileImageData {
            profileImageView.image = UIImage(data: profileData)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .gray
        }
        
        prodTitleLabel.text = product?.name ?? "Product not found"
        priceLabel.text = "Rs. \(Int(product?.price ?? 0))"
        
        durationLabel.text = "Duration: \(request.duration)"
        
        if let coverData = product?.coverImage {
            productImgView.image = UIImage(data: coverData)
        } else {
            productImgView.image = nil
        }
        
        // --- Setup Buttons Based on Status and Role ---
        actionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let status = request.status
        
        if status == "pending" {
            if isLender {
                let cancelBtn = createButton(title: "Decline", color: "#FF5722", isOutline: true)
                let chatBtn = createButton(title: "Chat", color: "#FF5722", isOutline: true)
                let acceptBtn = createButton(title: "Accept", color: "#FF5722", isOutline: false)
                
                cancelBtn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
                chatBtn.addTarget(self, action: #selector(chatTapped), for: .touchUpInside)
                acceptBtn.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
                
                actionStack.distribution = .fill
                actionStack.addArrangedSubview(cancelBtn)
                actionStack.addArrangedSubview(chatBtn)
                actionStack.addArrangedSubview(acceptBtn)
                
                NSLayoutConstraint.activate([
                    cancelBtn.widthAnchor.constraint(equalToConstant: 75),
                    chatBtn.widthAnchor.constraint(equalToConstant: 75)
                ])
            } else {
                let pendingLabel = UILabel()
                pendingLabel.text = "Request Pending"
                pendingLabel.font = .systemFont(ofSize: 14, weight: .bold)
                pendingLabel.textColor = .gray
                pendingLabel.textAlignment = .center
                
                let cancelBtn = createButton(title: "Cancel", color: "#FF5722", isOutline: true)
                cancelBtn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
                
                actionStack.distribution = .fill
                actionStack.addArrangedSubview(pendingLabel)
                actionStack.addArrangedSubview(cancelBtn)
                
                NSLayoutConstraint.activate([
                    cancelBtn.widthAnchor.constraint(equalToConstant: 100)
                ])
            }
        } else {
            let statusLabel = UILabel()
            statusLabel.text = "Status: \(request.status.capitalized)"
            statusLabel.font = .systemFont(ofSize: 14, weight: .bold)
            statusLabel.textColor = request.status == "accepted" ? .systemGreen : .systemRed
            statusLabel.textAlignment = .center
            actionStack.addArrangedSubview(statusLabel)
            
            if request.status == "accepted" {
                if !isLender {
                    // Borrower actions for accepted request
                    actionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    
                    let returnBtn = createButton(title: "Mark as Returned", color: "#4CAF50", isOutline: false)
                    let delayBtn = createButton(title: "Report Delay", color: "#FFC107", isOutline: false)
                    
                    returnBtn.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)
                    delayBtn.addTarget(self, action: #selector(delayTapped), for: .touchUpInside)
                    
                    actionStack.distribution = .fillEqually
                    actionStack.addArrangedSubview(returnBtn)
                    actionStack.addArrangedSubview(delayBtn)
                }
                
                let days = Int(request.duration.components(separatedBy: " ").first ?? "0") ?? 0
                if let returnDate = Calendar.current.date(byAdding: .day, value: days, to: request.requestDate) {
                    let df = DateFormatter()
                    df.dateFormat = "dd/MM/yyyy"
                    availableAgainLabel.text = "Available again on: \(df.string(from: returnDate))"
                    availableAgainLabel.isHidden = false
                }
            } else if request.status == "returned" {
                if isLender {
                    actionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    let viewDetailsBtn = createButton(title: "View Details", color: "#2196F3", isOutline: true)
                    let confirmBtn = createButton(title: "Confirm Return", color: "#4CAF50", isOutline: false)
                    
                    viewDetailsBtn.addTarget(self, action: #selector(viewDetailsTapped), for: .touchUpInside)
                    confirmBtn.addTarget(self, action: #selector(confirmReturnTapped), for: .touchUpInside)
                    
                    actionStack.distribution = .fillEqually
                    actionStack.addArrangedSubview(viewDetailsBtn)
                    actionStack.addArrangedSubview(confirmBtn)
                    
                    statusLabel.text = "Action Required: Return Confirmation"
                    statusLabel.textColor = .systemBlue
                } else {
                    statusLabel.text = "Waiting for Owner's Confirmation"
                    statusLabel.textColor = .systemOrange
                }
                availableAgainLabel.isHidden = true
            } else if request.status == "delayed" {
                let statusColor: UIColor = .systemOrange
                statusLabel.text = "Status: Delayed"
                statusLabel.textColor = statusColor
                availableAgainLabel.isHidden = true
            } else if status == "completed" {
                statusLabel.text = "Status: Completed"
                statusLabel.textColor = .systemGreen
                
                let alreadyReviewed = isLender ? request.isReviewedByLender : request.isReviewedByBorrower
                
                if !alreadyReviewed {
                    let rateBtn = createButton(title: "Rate User", color: "#FF5722", isOutline: true)
                    rateBtn.addTarget(self, action: #selector(rateTapped), for: .touchUpInside)
                    actionStack.addArrangedSubview(rateBtn)
                }
                
                availableAgainLabel.isHidden = true
            } else {
                availableAgainLabel.isHidden = true
            }
        }
    }
    
    @objc private func acceptTapped() { onAccept?() }
    @objc private func cancelTapped() { onCancel?() }
    @objc private func chatTapped() { onChat?() }
    @objc private func returnTapped() { onReturn?() }
    @objc private func delayTapped() { onDelay?() }
    @objc private func confirmReturnTapped() { onConfirmReturn?() }
    @objc private func viewDetailsTapped() { onViewReturnDetails?() }
    @objc private func rateTapped() { onRateUser?() }
    
    private func createButton(title: String, color: String, isOutline: Bool) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        btn.layer.cornerRadius = 8
        if isOutline {
            btn.layer.borderWidth = 1.5
            btn.layer.borderColor = UIColor(hex: color).cgColor
            btn.setTitleColor(UIColor(hex: color), for: .normal)
            btn.backgroundColor = .white
        } else {
            btn.backgroundColor = UIColor(hex: color)
            btn.setTitleColor(.white, for: .normal)
        }
        return btn
    }
}
