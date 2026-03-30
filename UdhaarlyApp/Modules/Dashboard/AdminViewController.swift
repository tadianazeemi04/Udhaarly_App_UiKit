//
//  AdminViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 19/03/2026.
//

import UIKit

class AdminViewController: UIViewController {

    // MARK: - Properties
    private var users: [LocalUser] = []
    private var products: [LocalProduct] = []
    private var isShowingUsers = true

    // MARK: - UI Components
    private let headerView: GradientView = {
        let view = GradientView()
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Admin Dashboard"
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Users", "Products"])
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .white
        sc.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        sc.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(AdminUserCell.self, forCellReuseIdentifier: "UserCell")
        tv.register(AdminProductCell.self, forCellReuseIdentifier: "ProductCell")
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(hex: "#FAFAFA")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(segmentedControl)
        headerView.addSubview(backButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            segmentedControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -40),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }

    private func fetchData() {
        users = LocalDataManager.shared.fetchAllUsers()
        products = LocalDataManager.shared.fetchProducts()
        tableView.reloadData()
    }

    @objc private func segmentChanged() {
        isShowingUsers = segmentedControl.selectedSegmentIndex == 0
        tableView.reloadData()
    }

    @objc private func didTapBack() {
        // Logout admin and go back
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let welcomeVC = HomeViewController()
            let nav = UINavigationController(rootViewController: welcomeVC)
            window.rootViewController = nav
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

extension AdminViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingUsers ? users.count : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingUsers {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! AdminUserCell
            cell.configure(with: users[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! AdminProductCell
            cell.configure(with: products[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isShowingUsers ? 90 : 100
    }
}

// MARK: - Custom Cells
class AdminUserCell: UITableViewCell {
    private let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowOpacity = 0.05
        v.layer.shadowRadius = 5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let emailLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let passwordLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .systemRed
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .gray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(container)
        container.addSubview(emailLabel)
        container.addSubview(passwordLabel)
        container.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            emailLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            emailLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),

            passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            passwordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),

            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15)
        ])
    }

    func configure(with user: LocalUser) {
        emailLabel.text = user.email
        passwordLabel.text = "Password: \(user.password)"
        nameLabel.text = "\(user.firstName) \(user.lastName)"
    }

    required init?(coder: NSCoder) { fatalError() }
}

class AdminProductCell: UITableViewCell {
    private let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowOpacity = 0.05
        v.layer.shadowRadius = 5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .brandOrange
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let ownerLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .gray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(priceLabel)
        container.addSubview(ownerLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            ownerLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            ownerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }

    func configure(with product: LocalProduct) {
        titleLabel.text = product.name
        priceLabel.text = "Rs. \(product.price) / \(product.duration)"
        ownerLabel.text = "Location: \(product.location)"
    }

    required init?(coder: NSCoder) { fatalError() }
}
