//
//  ProductDetailViewController.swift
//  UdhaarlyApp
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let product: LocalProduct
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    private let contentView = UIView()
    
    // Header Image Section
    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .systemGray4
        pc.currentPageIndicatorTintColor = .brandOrange
        return pc
    }()
    
    // Info Section
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let tagsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .leading
        return sv
    }()
    
    private let locationContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        return sv
    }()
    
    private let locationIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let timeContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        return sv
    }()
    
    private let timeIcon = UIImageView(image: UIImage(systemName: "clock"))
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // Profile Section
    private let profileContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .brandOrange
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.image = UIImage(named: "avatar_placeholder") // Simplified for now
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ali Hamid"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let profileRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.9 ★ (12 reviews)"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let viewProfileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View Profile", for: .normal)
        btn.backgroundColor = .white.withAlphaComponent(0.9)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    // Description Section
    private let descriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    // Bottom Action Bar
    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addDropShadow(opacity: 0.1, radius: 10, offset: CGSize(width: 0, height: -3))
        return view
    }()
    
    private let chatButton: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "bubble.left.and.bubble.right")
        config.imagePlacement = .top
        config.imagePadding = 4
        config.baseForegroundColor = .brandOrange
        
        let titleAttr = AttributedString("Chat", attributes: .init([.font: UIFont.systemFont(ofSize: 12, weight: .medium)]))
        config.attributedTitle = titleAttr
        
        btn.configuration = config
        return btn
    }()
    
    private let borrowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Request to Borrow", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    // MARK: - Initializer
    init(product: LocalProduct) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        configureWithProduct()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(bottomBar)
        scrollView.addSubview(contentView)
        
        [headerImageView, backButton, favoriteButton, pageControl, infoContainerView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [titleLabel, priceLabel, tagsStackView, locationContainer, timeContainer, profileContainer, descriptionHeaderLabel, descriptionTextLabel].forEach {
            infoContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [profileImageView, profileNameLabel, profileRatingLabel, viewProfileButton].forEach {
            profileContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [chatButton, borrowButton].forEach {
            bottomBar.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 450),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            pageControl.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            infoContainerView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -40),
            infoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            tagsStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            tagsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            locationContainer.topAnchor.constraint(equalTo: tagsStackView.bottomAnchor, constant: 20),
            locationContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            locationIcon.widthAnchor.constraint(equalToConstant: 16),
            locationIcon.heightAnchor.constraint(equalToConstant: 16),
            
            timeContainer.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            timeContainer.leadingAnchor.constraint(equalTo: locationContainer.trailingAnchor, constant: 30),
            
            timeIcon.widthAnchor.constraint(equalToConstant: 16),
            timeIcon.heightAnchor.constraint(equalToConstant: 16),
            
            profileContainer.topAnchor.constraint(equalTo: locationContainer.bottomAnchor, constant: 25),
            profileContainer.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor),
            profileContainer.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor),
            profileContainer.heightAnchor.constraint(equalToConstant: 80),
            
            profileImageView.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: profileContainer.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2),
            
            profileRatingLabel.leadingAnchor.constraint(equalTo: profileNameLabel.leadingAnchor),
            profileRatingLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 2),
            
            viewProfileButton.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -20),
            viewProfileButton.centerYAnchor.constraint(equalTo: profileContainer.centerYAnchor),
            viewProfileButton.widthAnchor.constraint(equalToConstant: 110),
            viewProfileButton.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionHeaderLabel.topAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: 25),
            descriptionHeaderLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            
            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor, constant: 12),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: descriptionHeaderLabel.leadingAnchor),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            descriptionTextLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -40),
            
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 100), // Adjusted for safe area
            
            chatButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 20),
            chatButton.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 15),
            chatButton.widthAnchor.constraint(equalToConstant: 56),
            
            borrowButton.leadingAnchor.constraint(equalTo: chatButton.trailingAnchor, constant: 15),
            borrowButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -20),
            borrowButton.topAnchor.constraint(equalTo: chatButton.topAnchor),
            borrowButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        locationIcon.tintColor = .brandOrange
        timeIcon.tintColor = .brandOrange
        
        locationContainer.addArrangedSubview(locationIcon)
        locationContainer.addArrangedSubview(locationLabel)
        
        timeContainer.addArrangedSubview(timeIcon)
        timeContainer.addArrangedSubview(timeLabel)
    }
    
    private func configureWithProduct() {
        titleLabel.text = product.name
        priceLabel.text = "Rs. \(Int(product.price)) /-"
        locationLabel.text = product.location
        timeLabel.text = "Posted 3 hours ago" // Static for demo as requested by visual
        descriptionTextLabel.text = product.productDescription
        
        if let coverData = product.coverImage, let image = UIImage(data: coverData) {
            headerImageView.image = image
        } else if let firstGalleryData = product.galleryImages.first, let image = UIImage(data: firstGalleryData) {
            headerImageView.image = image
        }
        
        // Setup tags
        let tags = ["Day", "Week", "Month"]
        tags.forEach { tag in
            let label = UILabel()
            label.text = tag
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.textColor = tag == "Day" ? .white : .brandOrange
            label.backgroundColor = tag == "Day" ? .brandOrange : .white
            label.layer.borderColor = UIColor.brandOrange.cgColor
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 6
            label.clipsToBounds = true
            label.textAlignment = .center
            
            // Add padding
            let container = UIView()
            container.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                label.widthAnchor.constraint(equalToConstant: 60),
                label.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            tagsStackView.addArrangedSubview(container)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
