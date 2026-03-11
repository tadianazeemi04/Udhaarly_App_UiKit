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
    
    private let categories = [
        (title: "Mobile", icon: "iphone"),
        (title: "Fashion", icon: "tshirt"),
        (title: "Home", icon: "house"),
        (title: "Electronics", icon: "desktopcomputer"),
        (title: "Books", icon: "book")
    ]
    
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
        fetchProducts() // Refresh when coming back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [searchContainer, categoryHeaderLabel, categoryCollectionView, premiumBannerView, recentAdsHeaderLabel, adsCollectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        premiumBannerView.addSubview(premiumIcon)
        premiumBannerView.addSubview(premiumTitleLabel)
        premiumBannerView.addSubview(premiumSubtitleLabel)
        premiumBannerView.addSubview(upgradeButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
            
            searchContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
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
}

// MARK: - CollectionView Delegate & DataSource
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else {
            return filteredProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCategoryCell.identifier, for: indexPath) as! DashboardCategoryCell
            cell.configure(with: categories[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardProductCell.identifier, for: indexPath) as! DashboardProductCell
            cell.configure(with: filteredProducts[indexPath.item])
            return cell
        }
    }
}
