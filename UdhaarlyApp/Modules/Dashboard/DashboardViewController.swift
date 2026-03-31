//
//  DashboardViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 02/03/2026.
//

import UIKit
import SwiftData


class DashboardViewController: UIViewController {

    // MARK: - Properties
    private var allProducts: [LocalProduct] = []
    private var filteredProducts: [LocalProduct] = []
    
    private let categoriesList: [Category] = [.all, .mobile, .fashion, .homeDecor, .electronics, .books, .software]
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.addDropShadow(opacity: 0.1, radius: 4)
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search products..."
        tf.font = .systemFont(ofSize: 16)
        return tf
    }()
    
    private let categoryHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let seeAllCategoriesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("See All", for: .normal)
        btn.setTitleColor(.brandOrange, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return btn
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 85)
        layout.minimumLineSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(DashboardCategoryCell.self, forCellWithReuseIdentifier: DashboardCategoryCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let premiumBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 22/255, green: 31/255, blue: 47/255, alpha: 1.0)
        view.layer.cornerRadius = 18
        view.addDropShadow(opacity: 0.3, radius: 10)
        return view
    }()
    
    private let premiumIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "bolt.fill"))
        iv.tintColor = UIColor(red: 253/255, green: 185/255, blue: 24/255, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let premiumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Udhaarly Premium"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 253/255, green: 185/255, blue: 24/255, alpha: 1.0)
        return label
    }()
    
    private let premiumSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock exclusive benefits and reach more people!"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let upgradeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Upgrade", for: .normal)
        btn.backgroundColor = UIColor(red: 50/255, green: 60/255, blue: 74/255, alpha: 1.0)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    @objc private func didtapUpgrade() {
        let up = SubscriptionViewController()
        up.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(up, animated: true)
    }
    
    private let recentAdsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Ads"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var adsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 60) / 2
        layout.itemSize = CGSize(width: width, height: 180)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false // Scroll is handled by main scrollview
        cv.register(DashboardProductCell.self, forCellWithReuseIdentifier: DashboardProductCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Header Components
    
    /// The application logo displayed in the top header section.
    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(resource: .udhaarlyLogo).withRenderingMode(.alwaysTemplate))
        iv.tintColor = .brandOrange
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    /// The interactive bell button that navigates to the notifications screen.
    private let bellButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.addDropShadow(opacity: 0.1, radius: 4)
        return btn
    }()
    
    /// A small red badge indicating the current unread notification count.
    private let bellBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 8
        view.isHidden = true // Hidden by default if zero unread
        return view
    }()
    
    /// Label for the number inside the bell badge.
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private var gradientLayer: CAGradientLayer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer = view.applyThemeGradient()
        setupLayout()
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchProducts() // Refresh the ads from local persistence.
        updateNotificationBadge() // Refresh the unread count when returning to dashboard.
        
        /// Listen for internal notifications to update the badge in real-time.
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationBadge), name: .didReceiveNewNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// Clean up observers to prevent redundant calls.
        NotificationCenter.default.removeObserver(self, name: .didReceiveNewNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupLayout() {
        
        upgradeButton.addTarget(self, action: #selector(didtapUpgrade), for: .touchUpInside)
        bellButton.addTarget(self, action: #selector(didTapBell), for: .touchUpInside)
        seeAllCategoriesButton.addTarget(self, action: #selector(didTapSeeAllCategories), for: .touchUpInside)
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [logoImageView, bellButton, searchContainer, categoryHeaderLabel, seeAllCategoriesButton, categoryCollectionView, premiumBannerView, recentAdsHeaderLabel, adsCollectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bellButton.addSubview(bellBadgeView)
        bellBadgeView.addSubview(badgeLabel)
        bellBadgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        premiumBannerView.addSubview(premiumIcon)
        premiumBannerView.addSubview(premiumTitleLabel)
        premiumBannerView.addSubview(premiumSubtitleLabel)
        premiumBannerView.addSubview(upgradeButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        bellButton.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        premiumIcon.translatesAutoresizingMaskIntoConstraints = false
        premiumTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        premiumSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        upgradeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            bellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bellButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            bellButton.widthAnchor.constraint(equalToConstant: 40),
            bellButton.heightAnchor.constraint(equalToConstant: 40),
            
            bellBadgeView.topAnchor.constraint(equalTo: bellButton.topAnchor, constant: 2),
            bellBadgeView.trailingAnchor.constraint(equalTo: bellButton.trailingAnchor, constant: -2),
            bellBadgeView.widthAnchor.constraint(equalToConstant: 16),
            bellBadgeView.heightAnchor.constraint(equalToConstant: 16),
            
            badgeLabel.centerXAnchor.constraint(equalTo: bellBadgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: bellBadgeView.centerYAnchor),
            
            searchContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            searchContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            searchContainer.heightAnchor.constraint(equalToConstant: 50),
            
            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -12),
            searchTextField.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor),
            
            categoryHeaderLabel.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 25),
            categoryHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            seeAllCategoriesButton.centerYAnchor.constraint(equalTo: categoryHeaderLabel.centerYAnchor),
            seeAllCategoriesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoryCollectionView.topAnchor.constraint(equalTo: categoryHeaderLabel.bottomAnchor, constant: 15),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 90),
            
            premiumBannerView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 25),
            premiumBannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            premiumBannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            premiumBannerView.heightAnchor.constraint(equalToConstant: 100),
            
            premiumIcon.leadingAnchor.constraint(equalTo: premiumBannerView.leadingAnchor, constant: 15),
            premiumIcon.topAnchor.constraint(equalTo: premiumBannerView.topAnchor, constant: 15),
            premiumIcon.widthAnchor.constraint(equalToConstant: 24),
            premiumIcon.heightAnchor.constraint(equalToConstant: 24),
            
            premiumTitleLabel.leadingAnchor.constraint(equalTo: premiumIcon.trailingAnchor, constant: 10),
            premiumTitleLabel.centerYAnchor.constraint(equalTo: premiumIcon.centerYAnchor),
            
            premiumSubtitleLabel.leadingAnchor.constraint(equalTo: premiumIcon.leadingAnchor),
            premiumSubtitleLabel.topAnchor.constraint(equalTo: premiumTitleLabel.bottomAnchor, constant: 8),
            premiumSubtitleLabel.trailingAnchor.constraint(equalTo: upgradeButton.leadingAnchor, constant: -10),
            
            upgradeButton.trailingAnchor.constraint(equalTo: premiumBannerView.trailingAnchor, constant: -15),
            upgradeButton.centerYAnchor.constraint(equalTo: premiumBannerView.centerYAnchor),
            upgradeButton.widthAnchor.constraint(equalToConstant: 90),
            upgradeButton.heightAnchor.constraint(equalToConstant: 35),
            
            recentAdsHeaderLabel.topAnchor.constraint(equalTo: premiumBannerView.bottomAnchor, constant: 30),
            recentAdsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            adsCollectionView.topAnchor.constraint(equalTo: recentAdsHeaderLabel.bottomAnchor, constant: 15),
            adsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            adsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            adsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            adsCollectionView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func fetchProducts() {
        allProducts = LocalDataManager.shared.fetchProducts()
        filteredProducts = allProducts.reversed() // Show newest first
        updateAdsHeight()
        adsCollectionView.reloadData()
    }
    
    private func updateAdsHeight() {
        let rows = ceil(Double(filteredProducts.count) / 2.0)
        let height = rows * 180 + (max(0, rows - 1) * 20)
        
        // Find existing height constraint and update it
        if let heightConstraint = adsCollectionView.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = CGFloat(height)
        }
    }
    
    // MARK: - Actions
    
    /// Navigates to the Notifications list with a custom push transition.
    @objc private func didTapBell() {
        let notificationsVC = NotificationsViewController()
        notificationsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    /// Updates the unread badge count by checking local persistence.
    @objc private func updateNotificationBadge() {
        /// Standardized key 'currentUserEmail' is used throughout the app for the active session.
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        let unreadCount = LocalDataManager.shared.fetchUnreadNotificationsCount(forEmail: currentEmail)
        
        DispatchQueue.main.async {
            self.bellBadgeView.isHidden = (unreadCount == 0)
            self.badgeLabel.text = "\(unreadCount)"
        }
    }
    
    @objc private func didTapSeeAllCategories() {
        let vc = CategoriesViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CollectionView Delegate & DataSource
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoriesList.count
        } else {
            return filteredProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCategoryCell.identifier, for: indexPath) as! DashboardCategoryCell
            let category = categoriesList[indexPath.item]
            cell.configure(with: (title: category.rawValue, icon: category.iconName))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardProductCell.identifier, for: indexPath) as! DashboardProductCell
            cell.configure(with: filteredProducts[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let selectedCategory = categoriesList[indexPath.item]
            let resultsVC = CategoryProductsViewController(category: selectedCategory)
            resultsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(resultsVC, animated: true)
        } else if collectionView == adsCollectionView {
            let product = filteredProducts[indexPath.item]
            let detailVC = ProductDetailViewController(product: product)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UITextField Delegate
extension DashboardViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Only run this if the selected text field is our searchTextField
        if textField == searchTextField {
            let searchVC = SearchViewController()
            searchVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(searchVC, animated: true)
            // Return false so the local keyboard doesn't actually pop up on the dashboard
            return false
        }
        return true
    }
}
