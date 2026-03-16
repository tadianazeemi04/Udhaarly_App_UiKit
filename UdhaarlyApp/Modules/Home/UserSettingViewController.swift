//
//  UserSettingViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 11/03/2026.
//


import UIKit

class UserSettingViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerBackgroundView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "ChatGPT Image Nov 19, 2025, 11_33_16 AM")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 42.5
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Profile"
        label.textColor = .white
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ali Hamid"
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.9 ★"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "📍 Model Town, Lahore"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()


    private let statsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()

    private let statsCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#FFF9F6")
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()

    private let generalSection: SettingsSectionView = {
        let section = SettingsSectionView(title: "General")
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }()

    private let securitySection: SettingsSectionView = {
        let section = SettingsSectionView(title: "Security")
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStats()
        setupSections()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerBackgroundView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(statsCard)
        statsCard.addSubview(statsStackView)
        contentView.addSubview(generalSection)
        contentView.addSubview(securitySection)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerBackgroundView.heightAnchor.constraint(equalToConstant: 280),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 85),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 85),
            profileImageView.heightAnchor.constraint(equalToConstant: 85),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),

            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            ratingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            locationLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            statsCard.topAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: -33),
            statsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsCard.heightAnchor.constraint(equalToConstant: 100),

            statsStackView.topAnchor.constraint(equalTo: statsCard.topAnchor),
            statsStackView.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor, constant: 10),
            statsStackView.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -10),
            statsStackView.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor),

            generalSection.topAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: 30),
            generalSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            generalSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            securitySection.topAnchor.constraint(equalTo: generalSection.bottomAnchor, constant: 20),
            securitySection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            securitySection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            securitySection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }

    private func setupStats() {
        let items = [
            StatItem(value: "4.9", label: "★ Rating"),
            StatItem(value: "3", label: "Ads"),
            StatItem(value: "2", label: "Pending Requests"),
            StatItem(value: "15", label: "Reviews")
        ]
        
        for (index, item) in items.enumerated() {
            let itemView = StatItemView(value: item.value, label: item.label)
            statsStackView.addArrangedSubview(itemView)
            
            if index < items.count - 1 {
                let divider = UIView()
                divider.backgroundColor = UIColor(white: 0, alpha: 0.1)
                divider.translatesAutoresizingMaskIntoConstraints = false
                divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
                divider.heightAnchor.constraint(equalToConstant: 40).isActive = true
                statsStackView.addArrangedSubview(divider)
            }
        }
    }

    private func setupSections() {
        generalSection.addRows([
            SettingsRow(icon: "doc.text", title: "Request", iconBg: "#EFF6FF", iconColor: "#007AFF"),
            SettingsRow(icon: "heart", title: "Favorites", iconBg: "#FEF2F2", iconColor: "#FD0000"),
            SettingsRow(icon: "mappin.circle", title: "Saved Addresses", iconBg: "#EFF6FF", iconColor: "#007AFF"),
            SettingsRow(icon: "creditcard", title: "Payment Methods", iconBg: "#F5F3FF", iconColor: "#AD46FF"),
            SettingsRow(icon: "crown", title: "Pricing Plans", iconBg: "#FFEDD4", iconColor: "#FF5722")
        ]) { [weak self] title in
            if title == "Pricing Plans" {
                let vc = SubscriptionViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if title == "Request" {
                let vc = RequestsViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        securitySection.addRows([
            SettingsRow(icon: "shield", title: "Privacy Policy", iconBg: "#F0FDF4", iconColor: "#00C951"),
            SettingsRow(icon: "gearshape", title: "Settings", iconBg: "#F3F4F6", iconColor: "#6A7282"),
            SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Logout", iconBg: "#FEF2F2", iconColor: "#FF0000")
        ])
    }
}

// MARK: - Helper Structs
struct StatItem {
    let value: String
    let label: String
}

struct SettingsRow {
    let icon: String
    let title: String
    let iconBg: String
    let iconColor: String
}

// MARK: - Custom Views
class StatItemView: UIView {
    init(value: String, label: String) {
        super.init(frame: .zero)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        valueLabel.textAlignment = .center
        valueLabel.textColor = .black
        
        let iconLabel = UILabel()
        if label.contains("★") {
            iconLabel.text = "★"
            iconLabel.textColor = UIColor(hex: "#FFB800")
            iconLabel.font = .systemFont(ofSize: 12)
        }
        
        let subLabel = UILabel()
        subLabel.text = label.replacingOccurrences(of: "★ ", with: "")
        subLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subLabel.textColor = .darkGray
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 2
        
        let bottomStack = UIStackView(arrangedSubviews: [iconLabel, subLabel].filter { $0.text != nil })
        bottomStack.axis = .horizontal
        bottomStack.spacing = 4
        bottomStack.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [valueLabel, bottomStack])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}

class SettingsSectionView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    func addRows(_ rows: [SettingsRow], completion: ((String) -> Void)? = nil) {
        for (index, row) in rows.enumerated() {
            let rowView = SettingsRowView(row: row)
            rowView.onTap = {
                completion?(row.title)
            }
            stackView.addArrangedSubview(rowView)
            
            if index < rows.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor(white: 0, alpha: 0.1)
                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                stackView.addArrangedSubview(separator)
            }
        }
    }
}

class SettingsRowView: UIView {
    var onTap: (() -> Void)?

    init(row: SettingsRow) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor(hex: row.iconBg)
        iconContainer.layer.cornerRadius = 16
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: row.icon))
        iconView.tintColor = UIColor(hex: row.iconColor)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = row.title
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .black.withAlphaComponent(0.6)
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .gray
        chevron.contentMode = .scaleAspectFit
        
        let stack = UIStackView(arrangedSubviews: [iconContainer, titleLabel, UIView(), chevron])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        iconContainer.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            iconContainer.widthAnchor.constraint(equalToConstant: 32),
            iconContainer.heightAnchor.constraint(equalToConstant: 32),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            chevron.widthAnchor.constraint(equalToConstant: 12),
            chevron.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        resetBackground()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        resetBackground()
    }
    private func resetBackground() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .clear
        }
    }

    @objc private func handleTap() {
        onTap?()
    }

    required init?(coder: NSCoder) { fatalError() }
}




