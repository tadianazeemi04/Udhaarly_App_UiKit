//
//  SubscriptionViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 13/03/2026.
//

import UIKit

class SubscriptionViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        sv.contentInsetAdjustmentBehavior = .never
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerGradient: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Subscription"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let crownIconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#FFEDD4")
        view.layer.cornerRadius = 40.5
        return view
    }()

    private let crownIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "crown.fill")
        iv.tintColor = UIColor(hex: "#FF5722")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let upgradeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upgrade to Premium"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let upgradeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unlock unlimited ads and premium features to grow your business."
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 27
        sv.alignment = .center
        return sv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerGradient)
        contentView.addSubview(backButton)
        contentView.addSubview(navTitleLabel)
        
        contentView.addSubview(crownIconContainer)
        crownIconContainer.addSubview(crownIcon)
        
        contentView.addSubview(upgradeTitleLabel)
        contentView.addSubview(upgradeSubtitleLabel)
        
        contentView.addSubview(stackView)
        
        setupPlans()

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

            headerGradient.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerGradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerGradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerGradient.heightAnchor.constraint(equalToConstant: 361),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            navTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 23),

            crownIconContainer.topAnchor.constraint(equalTo: navTitleLabel.bottomAnchor, constant: 34),
            crownIconContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            crownIconContainer.widthAnchor.constraint(equalToConstant: 81),
            crownIconContainer.heightAnchor.constraint(equalToConstant: 81),

            crownIcon.centerXAnchor.constraint(equalTo: crownIconContainer.centerXAnchor),
            crownIcon.centerYAnchor.constraint(equalTo: crownIconContainer.centerYAnchor),
            crownIcon.widthAnchor.constraint(equalToConstant: 40),
            crownIcon.heightAnchor.constraint(equalToConstant: 35),

            upgradeTitleLabel.topAnchor.constraint(equalTo: crownIconContainer.bottomAnchor, constant: 12),
            upgradeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            upgradeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            upgradeSubtitleLabel.topAnchor.constraint(equalTo: upgradeTitleLabel.bottomAnchor, constant: 12),
            upgradeSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            upgradeSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            stackView.topAnchor.constraint(equalTo: headerGradient.bottomAnchor, constant: -33),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }

    private func setupPlans() {
        let freePlan = PlanCardView(
            title: "Free Plan",
            price: "Rs. 0",
            subtitle: "For casual user",
            features: ["Post up to 3 ads", "Basic Support", "Standard Visibility"],
            isCurrent: true,
            isRecommended: false
        )
        
        let premiumPlan = PlanCardView(
            title: "Premium Plan",
            price: "Rs. 1000",
            subtitle: "For power sellers",
            priceSuffix: "/ month",
            features: ["Unlimited Ads", "Priority Support", "Featured listing", "Verified badge"],
            isCurrent: false,
            isRecommended: true
        )
        
        stackView.addArrangedSubview(freePlan)
        stackView.addArrangedSubview(premiumPlan)
        
        NSLayoutConstraint.activate([
            freePlan.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -15),
            premiumPlan.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -15)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PlanCardView
class PlanCardView: UIView {
    init(title: String, price: String, subtitle: String, priceSuffix: String? = nil, features: [String], isCurrent: Bool, isRecommended: Bool) {
        super.init(frame: .zero)
        setupUI(title: title, price: price, subtitle: subtitle, priceSuffix: priceSuffix, features: features, isCurrent: isCurrent, isRecommended: isRecommended)
    }

    required init?(coder: NSCoder) { fatalError() }
    private func setupUI(title: String, price: String, subtitle: String, priceSuffix: String?, features: [String], isCurrent: Bool, isRecommended: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Main container for the card content with border and background
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
        container.addDropShadow(opacity: 0.1, radius: 10, offset: CGSize(width: 0, height: 4))
        addSubview(container)
        
        let gradient = GradientView()
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.colors = [UIColor(hex: "#FEF3EF"), UIColor(hex: "#FFFCFC")]
        gradient.layer.cornerRadius = 20
        gradient.clipsToBounds = true
        container.addSubview(gradient)
        
        if isRecommended {
            container.layer.borderWidth = 2
            container.layer.borderColor = UIColor(hex: "#FF5722").cgColor
            
            let badgeContainer = UIView()
            badgeContainer.translatesAutoresizingMaskIntoConstraints = false
            badgeContainer.backgroundColor = UIColor(hex: "#FF5722")
            badgeContainer.layer.cornerRadius = 10
            addSubview(badgeContainer) // Add to self, so it's ON TOP of container border
            
            let badgeLabel = UILabel()
            badgeLabel.translatesAutoresizingMaskIntoConstraints = false
            badgeLabel.text = "RECOMMENDED"
            badgeLabel.textColor = .white
            badgeLabel.font = .systemFont(ofSize: 10, weight: .bold)
            badgeLabel.textAlignment = .center
            badgeContainer.addSubview(badgeLabel)
            
            NSLayoutConstraint.activate([
                badgeContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: -11),
                badgeContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                badgeContainer.widthAnchor.constraint(equalToConstant: 116),
                badgeContainer.heightAnchor.constraint(equalToConstant: 22),
                
                badgeLabel.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
                badgeLabel.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor)
            ])
        }

        let headerStack = UIStackView()
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        
        let priceLabel = UILabel()
        priceLabel.text = price
        priceLabel.font = .systemFont(ofSize: 20, weight: .bold)
        priceLabel.textColor = .black
        
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(priceLabel)
        
        let subtitleStack = UIStackView()
        subtitleStack.translatesAutoresizingMaskIntoConstraints = false
        subtitleStack.axis = .horizontal
        subtitleStack.distribution = .fill
        subtitleStack.spacing = 11
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = subtitle
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subTitleLabel.textColor = .black.withAlphaComponent(0.6)
        
        subtitleStack.addArrangedSubview(subTitleLabel)
        
        if let suffix = priceSuffix {
            let suffixLabel = UILabel()
            suffixLabel.text = suffix
            suffixLabel.font = .systemFont(ofSize: 12, weight: .medium)
            suffixLabel.textColor = .black.withAlphaComponent(0.38)
            suffixLabel.textAlignment = .right
            subtitleStack.addArrangedSubview(suffixLabel)
        } else {
            subtitleStack.addArrangedSubview(UIView())
        }
        
        let featuresStack = UIStackView()
        featuresStack.translatesAutoresizingMaskIntoConstraints = false
        featuresStack.axis = .vertical
        featuresStack.spacing = 10
        
        for feature in features {
            let item = FeatureItemView(text: feature)
            featuresStack.addArrangedSubview(item)
        }
        
        let actionButton = UIButton(type: .system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle(isCurrent ? "Current Plan" : "Subscribe Now", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        actionButton.layer.cornerRadius = 8
        if isCurrent {
            actionButton.backgroundColor = .white
            actionButton.setTitleColor(UIColor(hex: "#101828"), for: .normal)
            actionButton.addDropShadow(opacity: 0.1, radius: 4, offset: CGSize(width: 0, height: 2))
        } else {
            actionButton.backgroundColor = UIColor(hex: "#FF5722")
            actionButton.setTitleColor(.white, for: .normal)
        }
        
        container.addSubview(headerStack)
        container.addSubview(subtitleStack)
        container.addSubview(featuresStack)
        container.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),

            gradient.topAnchor.constraint(equalTo: container.topAnchor),
            gradient.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gradient.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            headerStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            headerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25),
            
            subtitleStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 4),
            subtitleStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            subtitleStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25),
            
            featuresStack.topAnchor.constraint(equalTo: subtitleStack.bottomAnchor, constant: 19),
            featuresStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            featuresStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25),
            
            actionButton.topAnchor.constraint(equalTo: featuresStack.bottomAnchor, constant: 19),
            actionButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25),
            actionButton.heightAnchor.constraint(equalToConstant: 34),
            actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - FeatureItemView
class FeatureItemView: UIView {
    init(text: String) {
        super.init(frame: .zero)
        
        let iconBg = UIView()
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.backgroundColor = UIColor(hex: "#DBFCE7")
        iconBg.layer.cornerRadius = 9
        
        let icon = UIImageView(image: UIImage(systemName: "checkmark"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = UIColor(hex: "#18AF50")
        icon.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.6)
        
        addSubview(iconBg)
        iconBg.addSubview(icon)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            iconBg.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconBg.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconBg.widthAnchor.constraint(equalToConstant: 18),
            iconBg.heightAnchor.constraint(equalToConstant: 18),
            
            icon.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 10),
            icon.heightAnchor.constraint(equalToConstant: 10),
            
            label.leadingAnchor.constraint(equalTo: iconBg.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
