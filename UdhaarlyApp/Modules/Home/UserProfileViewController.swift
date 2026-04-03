//
//  UserProfileViewController.swift
//  UdhaarlyApp
//

import UIKit

class UserProfileViewController: UIViewController {

    private let user: LocalUser
    private var reviews: [LocalReview] = []
    private var products: [LocalProduct] = []
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .brandOrange
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Profile"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .brandOrange
        return label
    }()
    
    private let callButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "phone"), for: .normal)
        btn.tintColor = .brandOrange
        return btn
    }()
    
    // Header Components
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50
        iv.backgroundColor = .systemGray5
        iv.image = UIImage(named: "avatar_placeholder")
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating "
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Initializer
    init(user: LocalUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeader()
        setupTableView()
        setupLayout()
        configureHeader()
    }
    
    private func setupHeader() {
        [backButton, titleLabel, callButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            callButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            callButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        tableView.register(UserProductsCell.self, forCellReuseIdentifier: UserProductsCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        let headerHeight: CGFloat = 110
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))
        
        // Add a soft gradient background to header
        let gradient = CAGradientLayer()
        gradient.frame = headerView.bounds
        gradient.colors = [
            UIColor.brandOrange.withAlphaComponent(0.05).cgColor,
            UIColor.white.cgColor
        ]
        headerView.layer.insertSublayer(gradient, at: 0)
        
        [profileImageView, nameLabel, ratingLabel, ratingStack].forEach {
            headerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.heightAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            ratingStack.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            ratingStack.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8)
        ])
        
        // Setup Stars
        for _ in 1...5 {
            let iv = UIImageView(image: UIImage(systemName: "star.fill"))
            iv.tintColor = .systemYellow
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.widthAnchor.constraint(equalToConstant: 18).isActive = true
            iv.heightAnchor.constraint(equalToConstant: 18).isActive = true
            ratingStack.addArrangedSubview(iv)
        }
        
        tableView.tableHeaderView = headerView
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureHeader() {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        if let imageData = user.profileImageData {
            profileImageView.image = UIImage(data: imageData)
        }
    }
    
    private func fetchData() {
        reviews = LocalDataManager.shared.fetchReviews(forEmail: user.email)
        products = LocalDataManager.shared.fetchProducts(forEmail: user.email)
        tableView.reloadData()
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Location, Reviews, Products
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 } // Location
        if section == 1 { return reviews.count } // Reviews
        return 1 // Products
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            let container = UIView()
            container.backgroundColor = UIColor(hex: "#F8F9FA")
            container.layer.cornerRadius = 12
            container.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(container)
            
            let icon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
            icon.tintColor = .brandOrange
            icon.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(icon)
            
            let title = UILabel()
            title.text = "Location"
            title.font = .systemFont(ofSize: 15, weight: .bold)
            title.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(title)
            
            let detail = UILabel()
            detail.text = user.location
            detail.font = .systemFont(ofSize: 14)
            detail.textColor = .darkGray
            detail.textAlignment = .right
            detail.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(detail)
            
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
                container.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                container.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                container.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 5),
                container.heightAnchor.constraint(equalToConstant: 50),
                
                icon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
                icon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: 20),
                icon.heightAnchor.constraint(equalToConstant: 20),
                
                title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
                title.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                
                detail.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
                detail.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                detail.leadingAnchor.constraint(greaterThanOrEqualTo: title.trailingAnchor, constant: 10)
            ])
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
            cell.configure(with: reviews[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProductsCell.identifier, for: indexPath) as! UserProductsCell
            cell.configure(with: products)
            cell.didSelectProduct = { [weak self] product in
                let vc = ProductDetailViewController(product: product)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView()
            let label = UILabel()
            label.text = "Products"
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textColor = .black
            view.addSubview(label)
            
            let line = UIView()
            line.backgroundColor = .brandOrange
            line.layer.cornerRadius = 2
            line.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(line)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                line.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                line.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
                line.widthAnchor.constraint(equalToConstant: 40),
                line.heightAnchor.constraint(equalToConstant: 3)
            ])
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 40 : 0
    }
}

// MARK: - UserProductsCell
class UserProductsCell: UITableViewCell {
    static let identifier = "UserProductsCell"
    private var products: [LocalProduct] = []
    var didSelectProduct: ((LocalProduct) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(DashboardProductCell.self, forCellWithReuseIdentifier: DashboardProductCell.identifier)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with products: [LocalProduct]) {
        self.products = products
        collectionView.reloadData()
    }
}

extension UserProductsCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardProductCell.identifier, for: indexPath) as! DashboardProductCell
        cell.configure(with: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectProduct?(products[indexPath.item])
    }
}
