//
//  AddProductViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 05/03/2026.
//

import UIKit
import PhotosUI

class AddProductViewController: UIViewController, PHPickerViewControllerDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let addProductLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Product"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private func createLabeledField(label: String, placeholder: String, icon:String? = nil) -> UIView {
        
        let titleLabel = UILabel()
        let attributedText = NSMutableAttributedString(string: label, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.black
        ])
        
        attributedText.append(NSAttributedString(string: "*", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.red
        ]))
        
        titleLabel.attributedText = attributedText
        
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.layer.cornerRadius = 15
        tf.layer.borderWidth = 1.5
        tf.layer.borderColor = UIColor.brandOrange.cgColor
        tf.setLeftPaddingPoints(15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.addDropShadow()
        
        if let iconName = icon {
            let iconView = UIImageView(image: UIImage(systemName: iconName))
            iconView.tintColor = .gray
            iconView.contentMode = .scaleAspectFit
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            iconView.frame = CGRect(x: 10, y: 5, width: 25, height: 20)
            container.addSubview(iconView)
            
            tf.rightView = container
            tf.rightViewMode = .always
        }
        
        let labelContainer = UIStackView(arrangedSubviews: [titleLabel,tf])
        labelContainer.axis = .vertical
        labelContainer.spacing = 8
        return labelContainer
        
    }
    
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.image = UIImage(systemName: "plus.circle")
        iv.contentMode = .center
        iv.tintColor = .orange
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var nameField: UIStackView = createLabeledField(label: "Product Name", placeholder: "Ex: Nikon coolpix A300") as! UIStackView
    private lazy var locationField: UIStackView = createLabeledField(label: "Lacation", placeholder: "Select Location", icon: "chevron.right") as! UIStackView
    private lazy var categoryField: UIStackView = createLabeledField(label: "Category", placeholder: "Select Category", icon: "chevron.right") as! UIStackView
    
    private lazy var priceField: UIStackView = createLabeledField(label: "Price (Rs.)", placeholder: "200") as! UIStackView
    private lazy var durationField: UIStackView = createLabeledField(label: "Duration", placeholder: "1 Day") as! UIStackView
    
    private lazy var descriptionField: UIStackView = createLargeInputBox(label: "Product Description", placeholder: "Enter description...") as! UIStackView
    private lazy var highlightsField: UIStackView = createLargeInputBox(label: "Product Highlights", placeholder: "Enter highlights...") as! UIStackView

    private func createPriceDurationRow() -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.spacing = 16
        
        container.addArrangedSubview(priceField)
        container.addArrangedSubview(durationField)
        
        return container
    }

    private func createLargeInputBox(label: String, placeholder: String) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        
        let titleLabel = UILabel()
        titleLabel.text = label + "*"
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        let textView = UITextView()
        textView.layer.cornerRadius = 15
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = UIColor.brandOrange.cgColor
        textView.font = .systemFont(ofSize: 14)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        textView.addDropShadow()
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(textView)
        return stack
    }
    
    private let addProductButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Product →", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.addDropShadow(color: .brandOrange, opacity: 0.3, radius: 6, offset: CGSize(width: 0, height: 4))
        return btn
    }()
    
    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCoverImage))
        coverImageView.addGestureRecognizer(tap)
        addProductButton.addTarget(self, action: #selector(didTapAddProduct), for: .touchUpInside)
    }
    
    @objc private func didTapCoverImage() {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1. Create Section Labels (Matching your design)
        let productImagesLabel = UILabel()
        productImagesLabel.text = "Product Images*"
        productImagesLabel.font = .systemFont(ofSize: 16, weight: .medium)
            
        let promotionLabel = UILabel()
        promotionLabel.text = "Buyer Promotion Image*"
        promotionLabel.font = .systemFont(ofSize: 16, weight: .medium)
            
        // 2. Assemble the Main Stack
        let mainStack = UIStackView(arrangedSubviews: [
            addProductLabel,
            nameField,
            locationField,
            categoryField,
            productImagesLabel,
            // (Optional: Insert your horizontal CollectionView for 5 images here later)
            promotionLabel,
            coverImageView,
            createPriceDurationRow(),
            descriptionField,
            highlightsField,
            addProductButton
        ])
            
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
            
        contentView.addSubview(mainStack)
            
        // 3. Set Constraints
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
                
            // Cover Image Height
            coverImageView.heightAnchor.constraint(equalToConstant: 150),
                
            // Add Product Button Height
            addProductButton.heightAnchor.constraint(equalToConstant: 55),
                
            // Main Stack Constraints
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupActions()
            
        // Hide keyboard when tapping outside
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
            
    }
    
    // MARK: - PHPickerViewControllerDelegate
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    // Set the cover image and change mode to fit nicely
                    self?.coverImageView.image = image
                    self?.coverImageView.contentMode = .scaleAspectFill
                }
            }
        }
        
        // MARK: - Save Data Logic
        @objc private func didTapAddProduct() {
            // 1. Extract values (assuming you add tags or outlets to your fields)
            let name = (nameField.arrangedSubviews[1] as? UITextField)?.text ?? ""
            let location = (locationField.arrangedSubviews[1] as? UITextField)?.text ?? ""
            let category = (categoryField.arrangedSubviews[1] as? UITextField)?.text ?? ""
            let priceString = (priceField.arrangedSubviews.compactMap { $0 as? UITextField }.first)?.text ?? "0"
            let duration = (durationField.arrangedSubviews.compactMap { $0 as? UITextField }.first)?.text ?? "1 Day"
            let desc = (descriptionField.arrangedSubviews.compactMap { $0 as? UITextView }.first)?.text ?? ""
            let highlights = (highlightsField.arrangedSubviews.compactMap { $0 as? UITextView }.first)?.text ?? ""
            let price = Double(priceString) ?? 0.0
            
            // 2. Convert Image to Data for SwiftData
            let imageData = coverImageView.image?.jpegData(compressionQuality: 0.8)
            
            // 3. Create the Model Instance
            // (Make sure your LocalProduct model is created in your Models folder)
            // Create the product (Notice: no 'id' needed now!)
                let newProduct = LocalProduct(
                    name: name,
                    location: location,
                    category: category.isEmpty ? "General" : category,
                    price: price,
                    duration: duration,
                    productDescription: desc,
                    highlights: highlights,
                    coverImage: imageData
                )
                
                // Save to SwiftData
                LocalDataManager.shared.saveProduct(product: newProduct)
                
                print("✅ Successfully saved: \(newProduct.name)")
            
            
            print("Saving Product: \(name) for Rs. \(price)")
            navigationController?.popViewController(animated: true)
        }
    
}

#Preview {
    AddProductViewController()
}
