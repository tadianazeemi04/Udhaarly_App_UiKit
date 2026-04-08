//
//  SavedAddressViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 24/03/2026.
//

import UIKit

class SavedAddressViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor(hex: "#F9FAFB")
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerGradient: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Saved Address"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "mappin.circle.fill")
        iv.tintColor = UIColor(hex: "#FF5722")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Home"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = UIColor(hex: "#F3F4F6")
        button.layer.cornerRadius = 15
        return button
    }()

    private let addressCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let dashedBorderLayer = CAShapeLayer()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Street 00, House 00/A, near bakery Model Town, Lahore, Punjab, Pakistan"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let phoneIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "phone.fill")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+92 300 1234567"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadUserData()
    }

    private func loadUserData() {
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail"),
              let user = LocalDataManager.shared.fetchUser(email: email) else {
            return
        }

        addressLabel.text = user.address.isEmpty ? "No address set" : user.address
        phoneLabel.text = user.phoneNumber.isEmpty ? "No phone number set" : user.phoneNumber
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateDashedBorder()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerGradient)
        contentView.addSubview(backButton)
        contentView.addSubview(navTitleLabel)
        
        contentView.addSubview(iconView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(addressCard)
        
        addressCard.addSubview(addressLabel)
        addressCard.addSubview(phoneLabel)
        addressCard.addSubview(phoneIcon)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerGradient.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerGradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerGradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerGradient.heightAnchor.constraint(equalToConstant: 140),

            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerGradient.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            navTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            iconView.topAnchor.constraint(equalTo: headerGradient.bottomAnchor, constant: 30),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            typeLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),

            editButton.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),

            addressCard.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 15),
            addressCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            addressCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            addressCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            
            addressLabel.topAnchor.constraint(equalTo: addressCard.topAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: addressCard.leadingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(equalTo: addressCard.trailingAnchor, constant: -15),

            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
            phoneLabel.bottomAnchor.constraint(equalTo: addressCard.bottomAnchor, constant: -20),

            phoneIcon.centerYAnchor.constraint(equalTo: phoneLabel.centerYAnchor),
            phoneIcon.trailingAnchor.constraint(equalTo: addressCard.trailingAnchor, constant: -15),
            phoneIcon.widthAnchor.constraint(equalToConstant: 16),
            phoneIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func updateDashedBorder() {
        dashedBorderLayer.strokeColor = UIColor(hex: "#FF5722").cgColor
        dashedBorderLayer.lineDashPattern = [6, 4]
        dashedBorderLayer.frame = addressCard.bounds
        dashedBorderLayer.fillColor = nil
        dashedBorderLayer.path = UIBezierPath(roundedRect: addressCard.bounds, cornerRadius: 12).cgPath
        dashedBorderLayer.lineWidth = 2
        
        if dashedBorderLayer.superlayer == nil {
            addressCard.layer.addSublayer(dashedBorderLayer)
        }
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }

    @objc private func editTapped() {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
