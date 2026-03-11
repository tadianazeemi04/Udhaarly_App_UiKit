//
//  DashboardProductCell.swift
//  UdhaarlyApp
//

import UIKit
import SwiftData

class DashboardProductCell: UICollectionViewCell {
    static let identifier = "DashboardProductCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addDropShadow(opacity: 0.1, radius: 8)
        return view
    }()
    
    private let clippingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        iv.clipsToBounds = true
        return iv
    }()
    
    private let detailsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // Changed to clear
        return view
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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .brandOrange
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(clippingView)
        clippingView.addSubview(productImageView)
        clippingView.addSubview(detailsContainer)
        
        detailsContainer.addSubview(titleLabel)
        detailsContainer.addSubview(priceLabel)
        detailsContainer.addSubview(locationLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        clippingView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            clippingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            clippingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            clippingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            clippingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            productImageView.topAnchor.constraint(equalTo: clippingView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: clippingView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: clippingView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: clippingView.heightAnchor, multiplier: 0.6),
            
            detailsContainer.topAnchor.constraint(equalTo: productImageView.bottomAnchor),
            detailsContainer.leadingAnchor.constraint(equalTo: clippingView.leadingAnchor), // Full width
            detailsContainer.trailingAnchor.constraint(equalTo: clippingView.trailingAnchor), // Full width
            detailsContainer.bottomAnchor.constraint(equalTo: clippingView.bottomAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 8), // Added constant
            priceLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 10), // Padding
            priceLabel.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -10),
            
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -10),
            
            locationLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 10),
            locationLabel.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with product: LocalProduct) {
        titleLabel.text = product.name
        priceLabel.text = "Rs. \(product.price)"
        locationLabel.text = product.location
        
        if let coverData = product.coverImage, let image = UIImage(data: coverData) {
            productImageView.image = image
        } else if let firstGalleryData = product.galleryImages.first, let image = UIImage(data: firstGalleryData) {
            productImageView.image = image
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
    }
}
