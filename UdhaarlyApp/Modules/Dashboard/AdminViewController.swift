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
    /// 0 = Users, 1 = Products, 2 = Backup
    private var currentSegment = 0

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
        let sc = UISegmentedControl(items: ["Users", "Products", "Backup"])
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

    /// Full-screen backup panel shown when the Backup segment is selected.
    private lazy var backupPanelView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#FAFAFA")
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let backupStatusCard: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.08
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.shadowRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let backupIconLabel: UILabel = {
        let l = UILabel()
        l.text = "🛡️"
        l.font = .systemFont(ofSize: 44)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let backupTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Recovery Backup"
        l.font = .systemFont(ofSize: 20, weight: .bold)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let backupDateLabel: UILabel = {
        let l = UILabel()
        l.text = "No backup found"
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let backupStatsLabel: UILabel = {
        let l = UILabel()
        l.text = ""
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var restoreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("🔄  Restore All Data", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .brandOrange
        btn.layer.cornerRadius = 14
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
        return btn
    }()

    private lazy var backupNowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("💾  Backup Now", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.setTitleColor(.brandOrange, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.brandOrange.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapBackupNow), for: .touchUpInside)
        return btn
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
        view.addSubview(backupPanelView)

        // Backup panel subviews
        backupPanelView.addSubview(backupStatusCard)
        backupStatusCard.addSubview(backupIconLabel)
        backupStatusCard.addSubview(backupTitleLabel)
        backupStatusCard.addSubview(backupDateLabel)
        backupStatusCard.addSubview(backupStatsLabel)
        backupPanelView.addSubview(restoreButton)
        backupPanelView.addSubview(backupNowButton)

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
            segmentedControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backupPanelView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            backupPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backupPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backupPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backupStatusCard.topAnchor.constraint(equalTo: backupPanelView.topAnchor, constant: 30),
            backupStatusCard.leadingAnchor.constraint(equalTo: backupPanelView.leadingAnchor, constant: 20),
            backupStatusCard.trailingAnchor.constraint(equalTo: backupPanelView.trailingAnchor, constant: -20),

            backupIconLabel.topAnchor.constraint(equalTo: backupStatusCard.topAnchor, constant: 24),
            backupIconLabel.centerXAnchor.constraint(equalTo: backupStatusCard.centerXAnchor),

            backupTitleLabel.topAnchor.constraint(equalTo: backupIconLabel.bottomAnchor, constant: 12),
            backupTitleLabel.centerXAnchor.constraint(equalTo: backupStatusCard.centerXAnchor),

            backupDateLabel.topAnchor.constraint(equalTo: backupTitleLabel.bottomAnchor, constant: 8),
            backupDateLabel.centerXAnchor.constraint(equalTo: backupStatusCard.centerXAnchor),
            backupDateLabel.leadingAnchor.constraint(equalTo: backupStatusCard.leadingAnchor, constant: 16),
            backupDateLabel.trailingAnchor.constraint(equalTo: backupStatusCard.trailingAnchor, constant: -16),

            backupStatsLabel.topAnchor.constraint(equalTo: backupDateLabel.bottomAnchor, constant: 6),
            backupStatsLabel.centerXAnchor.constraint(equalTo: backupStatusCard.centerXAnchor),
            backupStatsLabel.leadingAnchor.constraint(equalTo: backupStatusCard.leadingAnchor, constant: 16),
            backupStatsLabel.trailingAnchor.constraint(equalTo: backupStatusCard.trailingAnchor, constant: -16),
            backupStatsLabel.bottomAnchor.constraint(equalTo: backupStatusCard.bottomAnchor, constant: -24),

            restoreButton.topAnchor.constraint(equalTo: backupStatusCard.bottomAnchor, constant: 28),
            restoreButton.leadingAnchor.constraint(equalTo: backupPanelView.leadingAnchor, constant: 20),
            restoreButton.trailingAnchor.constraint(equalTo: backupPanelView.trailingAnchor, constant: -20),
            restoreButton.heightAnchor.constraint(equalToConstant: 54),

            backupNowButton.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 14),
            backupNowButton.leadingAnchor.constraint(equalTo: restoreButton.leadingAnchor),
            backupNowButton.trailingAnchor.constraint(equalTo: restoreButton.trailingAnchor),
            backupNowButton.heightAnchor.constraint(equalToConstant: 54),
        ])

        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }

    private func fetchData() {
        users = LocalDataManager.shared.fetchAllUsers()
        products = LocalDataManager.shared.fetchProducts()
        tableView.reloadData()
    }

    private func refreshBackupPanel() {
        guard let backup = BackupManager.shared.loadBackup() else {
            backupDateLabel.text = "No backup found yet"
            backupStatsLabel.text = "Use 'Backup Now' to create your first snapshot."
            restoreButton.isEnabled = false
            restoreButton.alpha = 0.4
            return
        }
        restoreButton.isEnabled = true
        restoreButton.alpha = 1.0

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        backupDateLabel.text = "Last backup: \(formatter.string(from: backup.backupDate))"
        backupStatsLabel.text = "👥 \(backup.users.count) users  |  📦 \(backup.products.count) products"
    }

    @objc private func segmentChanged() {
        currentSegment = segmentedControl.selectedSegmentIndex
        let isBackup = currentSegment == 2
        tableView.isHidden = isBackup
        backupPanelView.isHidden = !isBackup
        if isBackup {
            refreshBackupPanel()
        } else {
            tableView.reloadData()
        }
    }

    @objc private func didTapRestore() {
        let confirm = UIAlertController(
            title: "Restore All Data?",
            message: "This will re-import all users and products from the backup. Existing records will not be duplicated.",
            preferredStyle: .alert
        )
        confirm.addAction(UIAlertAction(title: "Restore", style: .destructive) { [weak self] _ in
            self?.performRestore()
        })
        confirm.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(confirm, animated: true)
    }

    private func performRestore() {
        let result = BackupManager.shared.restoreFromBackup()
        fetchData()
        let message = "✅ Restored \(result.restoredUsers) users and \(result.restoredProducts) products successfully."
        let alert = UIAlertController(title: "Restore Complete", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        refreshBackupPanel()
    }

    @objc private func didTapBackupNow() {
        backupNowButton.setTitle("Saving...", for: .normal)
        backupNowButton.isEnabled = false

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            BackupManager.shared.createBackup()
            DispatchQueue.main.async {
                self?.backupNowButton.setTitle("💾  Backup Now", for: .normal)
                self?.backupNowButton.isEnabled = true
                self?.refreshBackupPanel()
                let alert = UIAlertController(title: "Backup Saved", message: "Your data has been backed up to the recovery file.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }

    @objc private func didTapBack() {
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
        return currentSegment == 0 ? users.count : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSegment == 0 {
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
        return currentSegment == 0 ? 90 : 100
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
