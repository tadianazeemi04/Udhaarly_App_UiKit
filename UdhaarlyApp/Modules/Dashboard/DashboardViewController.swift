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
    

    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        gradientLayer = view.applyThemeGradient()
        
        setupLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    

}
