import UIKit

class RequestCardView: UIView {
    
    init(name: String, phone: String, isBorrower: Bool) {
        super.init(frame: .zero)
        setupUI(name: name, phone: phone, isBorrower: isBorrower)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI(name: String, phone: String, isBorrower: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        addDropShadow(opacity: 0.05, radius: 8, offset: CGSize(width: 0, height: 4))
        
        // --- Top Profile Section ---
        let profileImage = UIView()
        profileImage.backgroundColor = UIColor(hex: "#D9D9D9")
        profileImage.layer.cornerRadius = 15
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        let phoneIcon = UIImageView(image: UIImage(systemName: "phone.fill"))
        phoneIcon.tintColor = .black
        phoneIcon.contentMode = .scaleAspectFit
        
        let phoneLabel = UILabel()
        phoneLabel.text = phone
        phoneLabel.font = .systemFont(ofSize: 12)
        
        let eyeSlash = UIImageView(image: UIImage(systemName: "eye.slash"))
        eyeSlash.tintColor = .black
        eyeSlash.contentMode = .scaleAspectFit
        
        let topStack = UIStackView(arrangedSubviews: [profileImage, nameLabel, UIView(), phoneIcon, phoneLabel, eyeSlash])
        topStack.axis = .horizontal
        topStack.spacing = 8
        topStack.alignment = .center
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
        // --- Separator ---
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0, alpha: 0.1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        // --- Product Section ---
        let productImg = UIView()
        productImg.backgroundColor = UIColor(hex: "#565656")
        productImg.layer.cornerRadius = 8
        productImg.translatesAutoresizingMaskIntoConstraints = false
        
        let prodTitle = UILabel()
        prodTitle.text = "Canva pro all latest feature for 1 week to 1 month"
        prodTitle.font = .systemFont(ofSize: 12, weight: .medium)
        prodTitle.numberOfLines = 2
        
        let priceLabel = UILabel()
        priceLabel.text = "Rs. 200"
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        let dateLabel = UILabel()
        dateLabel.text = "Date: 20/11/2025"
        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .gray
        
        let durationLabel = UILabel()
        durationLabel.text = "Duration: Day"
        durationLabel.font = .systemFont(ofSize: 10)
        durationLabel.textColor = .gray
        
        let detailStack = UIStackView(arrangedSubviews: [prodTitle, priceLabel, dateLabel, durationLabel])
        detailStack.axis = .vertical
        detailStack.spacing = 2
        
        let productStack = UIStackView(arrangedSubviews: [productImg, detailStack])
        productStack.axis = .horizontal
        productStack.spacing = 12
        productStack.alignment = .top
        productStack.translatesAutoresizingMaskIntoConstraints = false
        
        // --- Actions Section ---
        let actionStack = UIStackView()
        actionStack.axis = .horizontal
        actionStack.spacing = 12
        actionStack.distribution = .fillEqually
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        
        if isBorrower {
            let cancelBtn = createButton(title: "Cancel", color: "#FF5722", isOutline: true)
            let chatBtn = createButton(title: "Chat", color: "#FF5722", isOutline: true)
            let acceptBtn = createButton(title: "Accept Request", color: "#FF5722", isOutline: false)
            
            // Adjust distribution for the wider button
            actionStack.distribution = .fill
            actionStack.addArrangedSubview(cancelBtn)
            actionStack.addArrangedSubview(chatBtn)
            actionStack.addArrangedSubview(acceptBtn)
            
            NSLayoutConstraint.activate([
                cancelBtn.widthAnchor.constraint(equalToConstant: 80),
                chatBtn.widthAnchor.constraint(equalToConstant: 80)
            ])
        } else {
            let pendingLabel = UILabel()
            pendingLabel.text = "Request Pending"
            pendingLabel.font = .systemFont(ofSize: 14, weight: .bold)
            pendingLabel.textColor = .gray
            pendingLabel.textAlignment = .center
            actionStack.addArrangedSubview(pendingLabel)
        }
        
        addSubview(topStack)
        addSubview(separator)
        addSubview(productStack)
        addSubview(actionStack)
        
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 30),
            profileImage.heightAnchor.constraint(equalToConstant: 30),
            
            productImg.widthAnchor.constraint(equalToConstant: 80),
            productImg.heightAnchor.constraint(equalToConstant: 60),
            
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
