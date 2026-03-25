//
//  DeletedAdsViewController.swift
//  UdhaarlyApp
//

import UIKit

class DeletedAdsViewController: UIViewController {

    // MARK: - UI Components
    private let headerView: GradientView = {
        let view = GradientView()
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        return view
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Deleted Ads"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(DeletedAdCell.self, forCellWithReuseIdentifier: DeletedAdCell.identifier)
        cv.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        return cv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No deleted ads"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    private var deletedProducts: [LocalProduct] = []
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchData() {
        let allDeleted = LocalDataManager.shared.fetchDeletedProducts()
        if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
            deletedProducts = allDeleted.filter { $0.publisherEmail == currentUserEmail }
        } else {
            deletedProducts = []
        }
        collectionView.reloadData()
        emptyLabel.isHidden = !deletedProducts.isEmpty
    }
}

extension DeletedAdsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deletedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeletedAdCell.identifier, for: indexPath) as! DeletedAdCell
        let product = deletedProducts[indexPath.item]
        cell.configure(with: product)
        
        cell.restoreAction = { [weak self] in
            let alert = UIAlertController(title: "Restore Ad?", message: "Do you want to restore '\(product.name)' to My Ads?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Restore", style: .default, handler: { _ in
                LocalDataManager.shared.restoreProduct(product: product)
                self?.fetchData()
            }))
            self?.present(alert, animated: true)
        }
        
        cell.permanentDeleteAction = { [weak self] in
            let alert = UIAlertController(title: "Permanently Delete?", message: "Are you sure? This will permanently remove '\(product.name)'. This cannot be undone.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete Permanently", style: .destructive, handler: { _ in
                LocalDataManager.shared.permanentlyDeleteProduct(product: product)
                self?.fetchData()
            }))
            self?.present(alert, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32 - 15) / 2
        return CGSize(width: width, height: width * 1.6) // Slightly taller to accommodate buttons
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // No action needed for deleted items other than buttons
    }
}
