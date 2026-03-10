//
//  DashboardViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 02/03/2026.
//

import UIKit

class DashboardViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Dashboard"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .brandOrange
        return label
    }()
    
    private let addProductButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add New Product", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 15
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.addDropShadow()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        
        addProductButton.addTarget(self, action: #selector(didTapAddProduct), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(addProductButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addProductButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addProductButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addProductButton.widthAnchor.constraint(equalToConstant: 200),
            addProductButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    @objc private func didTapAddProduct() {
        let addProductVC = AddProductViewController()
        navigationController?.pushViewController(addProductVC, animated: true)
    }

}

