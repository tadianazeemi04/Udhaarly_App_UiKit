//
//  DeletedAdCell.swift
//  UdhaarlyApp
//

import UIKit

class DeletedAdCell: UICollectionViewCell {
    
    static let identifier = "DeletedAdCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.addDropShadow(opacity: 0.1, radius: 8)
        return view
    }()
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .brandOrange
        return label
    }()
    
    private let actionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let restoreButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        btn.setImage(UIImage(systemName: "arrow.uturn.backward", withConfiguration: config), for: .normal)
        btn.tintColor = .systemGreen
        btn.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        btn.setImage(UIImage(systemName: "trash.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .systemRed
        btn.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    var restoreAction: (() -> Void)?
    var permanentDeleteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        [productImageView, titleLabel, priceLabel, actionsStack].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        actionsStack.addArrangedSubview(restoreButton)
        actionsStack.addArrangedSubview(deleteButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.45),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            actionsStack.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            actionsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            actionsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            actionsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            actionsStack.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
    
    @objc private func didTapRestore() { restoreAction?() }
    @objc private func didTapDelete() { permanentDeleteAction?() }
    
    func configure(with product: LocalProduct) {
        titleLabel.text = product.name
        priceLabel.text = "Rs. \(Int(product.price))"
        
        if let coverData = product.coverImage {
            productImageView.image = UIImage(data: coverData)
        } else {
            productImageView.image = UIImage(systemName: "photo")
            productImageView.tintColor = .lightGray
        }
    }
}
