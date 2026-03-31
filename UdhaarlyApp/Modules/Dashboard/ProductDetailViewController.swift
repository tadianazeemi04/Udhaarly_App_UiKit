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
    
    // Header Image Section (Gallery Slider)
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .systemGray6
        cv.dataSource = self
        cv.delegate = self
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return cv
    }()
    
    private var galleryImages: [Data] = []
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .systemGray4
        pc.currentPageIndicatorTintColor = UIColor(hex: "#FF6700")
        return pc
    }()
    
    // Info Section
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFF9F6") // Soft Peach/Cream
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
        label.textColor = UIColor(hex: "#FF6700") // Bright Orange
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
    private let profileContainer: GradientView = {
        let view = GradientView()
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        view.layer.cornerRadius = 16
        view.addDropShadow(opacity: 0.2, radius: 8)
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.image = UIImage(named: "avatar_placeholder")
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ali Hamid"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private let profileRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.9 ★ (12 reviews)"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let viewProfileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View Profile", for: .normal)
        btn.backgroundColor = UIColor(hex: "#FFF5F1") // Very light peach
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 22
        btn.addDropShadow(opacity: 0.15, radius: 4)
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
    
    // Highlights Section
    private let highlightsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Highlights"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let highlightsTextLabel: UILabel = {
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
        config.baseForegroundColor = UIColor(hex: "#FF6700")
        
        let titleAttr = AttributedString("Chat", attributes: .init([.font: UIFont.systemFont(ofSize: 12, weight: .medium)]))
        config.attributedTitle = titleAttr
        
        btn.configuration = config
        return btn
    }()
    
    private let borrowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Request to Borrow", for: .normal)
        btn.backgroundColor = UIColor(hex: "#FF6700")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(bottomBar)
        scrollView.addSubview(contentView)
        
        [imageCollectionView, backButton, favoriteButton, pageControl, infoContainerView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [titleLabel, priceLabel, tagsStackView, locationContainer, timeContainer, profileContainer, 
         descriptionHeaderLabel, descriptionTextLabel, 
         highlightsHeaderLabel, highlightsTextLabel].forEach {
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
            
            imageCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 450),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            pageControl.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            infoContainerView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: -40),
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
                       profileContainer.topAnchor.constraint(equalTo: locationContainer.bottomAnchor, constant: 30),
            profileContainer.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            profileContainer.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            profileContainer.heightAnchor.constraint(equalToConstant: 100), // Increased height to match mockup
            
            profileImageView.centerYAnchor.constraint(equalTo: profileContainer.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            profileNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: viewProfileButton.leadingAnchor, constant: -10),
            
            profileRatingLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 4),
            profileRatingLabel.leadingAnchor.constraint(equalTo: profileNameLabel.leadingAnchor),
            profileRatingLabel.trailingAnchor.constraint(lessThanOrEqualTo: viewProfileButton.leadingAnchor, constant: -10),
            
            viewProfileButton.centerYAnchor.constraint(equalTo: profileContainer.centerYAnchor),
            viewProfileButton.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -15),
            viewProfileButton.widthAnchor.constraint(equalToConstant: 130),
            viewProfileButton.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionHeaderLabel.topAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: 25),
            descriptionHeaderLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            
            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor, constant: 12),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: descriptionHeaderLabel.leadingAnchor),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            
            highlightsHeaderLabel.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 25),
            highlightsHeaderLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            
            highlightsTextLabel.topAnchor.constraint(equalTo: highlightsHeaderLabel.bottomAnchor, constant: 12),
            highlightsTextLabel.leadingAnchor.constraint(equalTo: highlightsHeaderLabel.leadingAnchor),
            highlightsTextLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            highlightsTextLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -40),
            
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
        
        locationIcon.tintColor = UIColor(hex: "#FF6700")
        timeIcon.tintColor = UIColor(hex: "#FF6700")
        
        locationContainer.addArrangedSubview(locationIcon)
        locationContainer.addArrangedSubview(locationLabel)
        
        timeContainer.addArrangedSubview(timeIcon)
        timeContainer.addArrangedSubview(timeLabel)
    }
    
    private func configureWithProduct() {
        titleLabel.text = product.name
        priceLabel.text = "Rs. \(Int(product.price)) /-"
        locationLabel.text = product.location
        timeLabel.text = timeAgoString(from: product.createdAt)
        descriptionTextLabel.text = product.productDescription
        highlightsTextLabel.text = product.highlights
        
        // Prepare gallery images uniquely
        var allImages: [Data] = []
        if let coverData = product.coverImage {
            allImages.append(coverData)
        }
        allImages.append(contentsOf: product.galleryImages)
        
        // Filter out duplicates while maintaining order
        var seen = Set<Data>()
        galleryImages = allImages.filter { data in
            if seen.contains(data) {
                return false
            } else {
                seen.insert(data)
                return true
            }
        }
        
        pageControl.numberOfPages = galleryImages.count
        pageControl.isHidden = galleryImages.count <= 1
        updateFavoriteButtonState()
        imageCollectionView.reloadData()
        
        // Setup User Profile Data
        if let email = product.publisherEmail,
           let user = LocalDataManager.shared.fetchUser(email: email) {
            profileNameLabel.text = "\(user.firstName) \(user.lastName)"
            if let imageData = user.profileImageData {
                profileImageView.image = UIImage(data: imageData)
            } else {
                profileImageView.image = UIImage(named: "avatar_placeholder")
            }
        } else {
            // Fallback for products without publisherEmail or if user not found
            profileNameLabel.text = "Udhaarly User"
            profileImageView.image = UIImage(named: "avatar_placeholder")
        }
        
        // Setup tags
        // Clear existing tags if any
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.text = product.duration
        label.font = .systemFont(ofSize: 12, weight: .bold) // Made bolder
        label.textColor = .white
        label.backgroundColor = UIColor(hex: "#FF6700")
        label.layer.borderColor = UIColor(hex: "#FF6700").cgColor
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
            // Dynamic width based on text, with minimum
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Add some horizontal padding inside the container for the label text
        label.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        tagsStackView.addArrangedSubview(container)
        
        // Check for availability
        updateBorrowButtonState()
    }

    private func updateBorrowButtonState() {
        if let acceptedRequest = LocalDataManager.shared.fetchAcceptedRequest(productId: product.id) {
            let days = Int(acceptedRequest.duration.components(separatedBy: " ").first ?? "0") ?? 0
            if let returnDate = Calendar.current.date(byAdding: .day, value: days, to: acceptedRequest.requestDate) {
                let df = DateFormatter()
                df.dateFormat = "dd/MM/yyyy"
                borrowButton.setTitle("Available on: \(df.string(from: returnDate))", for: .normal)
                borrowButton.backgroundColor = .systemGray4
                borrowButton.isEnabled = false
            } else {
                borrowButton.setTitle("Currently Borrowed", for: .normal)
                borrowButton.backgroundColor = .systemGray4
                borrowButton.isEnabled = false
            }
        } else {
            borrowButton.setTitle("Request to Borrow", for: .normal)
            borrowButton.backgroundColor = UIColor(hex: "#FF6700")
            borrowButton.isEnabled = true
        }
    }
    
    private func updateFavoriteButtonState() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let imageName = product.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        favoriteButton.tintColor = product.isFavorite ? .red : .black
    }
    
    @objc private func favoriteButtonTapped() {
        product.isFavorite.toggle()
        updateFavoriteButtonState()
        LocalDataManager.shared.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesChanged"), object: nil)
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        viewProfileButton.addTarget(self, action: #selector(viewProfileTapped), for: .touchUpInside)
        borrowButton.addTarget(self, action: #selector(borrowTapped), for: .touchUpInside)
    }
    
    @objc private func viewProfileTapped() {
        guard let email = product.publisherEmail,
              let publisher = LocalDataManager.shared.fetchUser(email: email) else {
            return
        }
        let vc = UserProfileViewController(user: publisher)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func borrowTapped() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            showAlert(title: "Not Logged In", message: "Please log in to make a request.")
            return
        }

        guard let publisherEmail = product.publisherEmail else {
            showAlert(title: "Error", message: "Product publisher information is missing.")
            return
        }

        if currentUserEmail == publisherEmail {
            showAlert(title: "Invalid Action", message: "You cannot request to borrow your own product.")
            return
        }
        
        if LocalDataManager.shared.hasExistingRequest(productId: product.id, borrowerEmail: currentUserEmail) {
            showAlert(title: "Request Pending", message: "You have already sent a request for this product.")
            return
        }

        let request = LocalRequest(
            productId: product.id,
            borrowerEmail: currentUserEmail,
            lenderEmail: publisherEmail,
            duration: product.duration
        )

        LocalDataManager.shared.saveRequest(request: request)
        NotificationCenter.default.post(name: NSNotification.Name("RequestsUpdated"), object: nil)
        showAlert(title: "Success", message: "Borrow request sent successfully!")
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeString = formatter.localizedString(for: date, relativeTo: Date())
        
        // Customizing "3 hours ago" to "Posted 3 hours ago"
        // Most formatters will output "3 hours ago" or "in 3 hours"
        // Let's ensure it starts with "Posted "
        
        var timeStr = relativeString
        if timeStr.lowercased() == "now" {
            return "Posted just now"
        }
        
        return "Posted \(timeStr)"
    }
}

// MARK: - CollectionView DataSource & Delegate
extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.configure(with: galleryImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            pageControl.currentPage = page
        }
    }
}

// MARK: - Image Cell
class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: Data) {
        imageView.image = UIImage(data: data)
    }
}
