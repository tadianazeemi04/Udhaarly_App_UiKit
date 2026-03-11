//
//  MyAdsViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 11/03/2026.
//

import UIKit

class MyAdsViewController: UIViewController {

    private let gradientLayer = CAGradientLayer()
    private let tableView = UITableView()
    private var products: [LocalProduct] = []
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "My Ads"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .brandOrange
        label.textAlignment = .center
        return label
    }()
    
    private let promoBanner: UIView = {
        let view = UIView()
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 255/255, green: 126/255, blue: 95/255, alpha: 1.0).cgColor,
            UIColor(red: 254/255, green: 180/255, blue: 123/255, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 20
        view.layer.insertSublayer(gradient, at: 0)
        view.layer.cornerRadius = 20
        view.addDropShadow(color: .brandOrange, opacity: 0.3, radius: 10, offset: CGSize(width: 0, height: 4))
        
        let title = UILabel()
        title.text = "Post 3 ads for free!"
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = .white
        
        let sub = UILabel()
        sub.text = "Want more? Subscribe to unlock unlimited\nads and premium features."
        sub.font = .systemFont(ofSize: 11, weight: .medium)
        sub.textColor = .white.withAlphaComponent(0.9)
        sub.numberOfLines = 2
        sub.textAlignment = .center
        
        view.addSubview(title)
        view.addSubview(sub)
        title.translatesAutoresizingMaskIntoConstraints = false
        sub.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sub.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            sub.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sub.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sub.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
        
        // Store the gradient for resizing
        view.accessibilityHint = "gradientContainer"
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupTableView()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        if let gradient = promoBanner.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = promoBanner.bounds
        }
    }
    
    private func setupBackground() {
        gradientLayer.colors = [
            UIColor(red: 108/255, green: 92/255, blue: 231/255, alpha: 0.15).cgColor, // Soft Purple
            UIColor(red: 255/255, green: 126/255, blue: 95/255, alpha: 0.1).cgColor,  // Soft Peach
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0.0, 0.4, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyAdCell.self, forCellReuseIdentifier: MyAdCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupLayout() {
        view.addSubview(headerLabel)
        view.addSubview(promoBanner)
        view.addSubview(tableView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        promoBanner.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            promoBanner.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            promoBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promoBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: promoBanner.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchData() {
        products = LocalDataManager.shared.fetchProducts()
        tableView.reloadData()
    }
}

#Preview{
    MyAdsViewController()
}

extension MyAdsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAdCell.identifier, for: indexPath) as? MyAdCell else {
            return UITableViewCell()
        }
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        cell.editAction = { [weak self] in
            // Handle edit
        }
        
        cell.shareAction = { [weak self] in
            let text = "Check out this product: \(product.name) for \(product.price)"
            let ac = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            self?.present(ac, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
