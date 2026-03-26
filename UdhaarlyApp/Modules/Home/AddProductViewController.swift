//
//  AddProductViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 05/03/2026.
//

import UIKit
import PhotosUI

class AddProductViewController: UIViewController, PHPickerViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    var productToEdit: LocalProduct?
    
    // Header Elements
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return btn
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Product"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .brandOrange
        label.textAlignment = .center
        return label
    }()
    
    // Input Fields
    private let nameFieldTitle = createTitleLabel(text: "Product Name")
    private lazy var nameTextField = createStyledTextField(placeholder: "Ex. Nikon coolpix A300 digital camera")
    private let nameCounterLabel = createCounterLabel(limit: 255)
    
    private let locationFieldTitle = createTitleLabel(text: "Location")
    private lazy var locationTextField = createStyledTextField(placeholder: "Search Location", icon: "mappin.and.ellipse")
    
    private let categoryFieldTitle = createTitleLabel(text: "Category")
    private lazy var categoryMenuButton = createMenuButton(placeholder: "Select Category", icon: "chevron.right")
    
    // Product Images Section
    private let productImagesTitle = createTitleLabel(text: "Product Images")
    private lazy var imageSlotsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        for i in 0..<5 {
            let slot = createPhotoSlot(index: i)
            stack.addArrangedSubview(slot)
        }
        return stack
    }()
    
    // Sequential Image Array (0-4: Product Images, 5: Promotion)
    private var selectedImages: [UIImage?] = Array(repeating: nil, count: 6)
    
    // Buyer Promotion Section
    private let promotionTitle = createTitleLabel(text: "Buyer Promotion Image")
    private lazy var promotionSlot: UIView = {
        let view = createPhotoSlot(index: 5, isLarge: true)
        return view
    }()
    
    private let promotionSubLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "White Background Image*"
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .black
        return lbl
    }()
    
    private let seeExampleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("See Example", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    // Price & Duration Section
    private let priceDurationTitle = createTitleLabel(text: "Price & Duration")
    private let priceLabel = createSubTitleLabel(text: "Price (Rs.)")
    private lazy var priceTextField: UITextField = {
        let tf = createStyledTextField(placeholder: "200")
        tf.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tf.keyboardType = .numberPad
        return tf
    }()
    
    private let durationLabel = createSubTitleLabel(text: "Duration")
    private lazy var durationNumberTextField: UITextField = {
        let tf = createStyledTextField(placeholder: "7")
        tf.keyboardType = .numberPad
        tf.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tf.textAlignment = .left
        return tf
    }()
    private lazy var durationUnitMenuButton: UIButton = {
        let btn = createMenuButton(placeholder: "Days", icon: "chevron.down")
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return btn
    }()
    
    // Price container removed the addPrice button
    
    // Description & Highlights
    private let descriptionTitle = createTitleLabel(text: "Product Description")
    private lazy var descriptionTextView = createLargeTextView(placeholder: "Ex. Nikon coolpix A300 digital camera")
    private let descriptionCounterLabel = createCounterLabel(limit: 0, isStatic: false)
    
    private let highlightsTitle = createTitleLabel(text: "Product Highlights")
    private lazy var highlightsTextView = createLargeTextView(placeholder: "Ex. Nikon coolpix A300 digital camera")
    private let highlightsCounterLabel = createCounterLabel(limit: 0, isStatic: false)
    
    private let addProductButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Product ", for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        btn.setImage(UIImage(systemName: "arrow.right", withConfiguration: config), for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.backgroundColor = .brandOrange
        btn.setTitleColor(.white, for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.addDropShadow(color: .brandOrange, opacity: 0.3, radius: 6, offset: CGSize(width: 0, height: 4))
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupDelegates()
        setupLayout()
        setupActions()
        setupMenus()
        setupKeyboardHandling()
        autoFillUserLocation()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        if productToEdit != nil {
            configureForEdit()
        }
    }
    
    private func configureForEdit() {
        guard let product = productToEdit else { return }
        headerTitleLabel.text = "Edit Product"
        addProductButton.setTitle("Update Product ", for: .normal)
        
        nameTextField.text = product.name
        locationTextField.text = product.location
        categoryMenuButton.setTitle(product.category, for: .normal)
        categoryMenuButton.setTitleColor(.black, for: .normal)
        
        // Price and Duration
        priceTextField.text = "\(Int(product.price))"
        let durationParts = product.duration.components(separatedBy: " ")
        if durationParts.count == 2 {
            durationNumberTextField.text = durationParts[0]
            durationUnitMenuButton.setTitle(durationParts[1], for: .normal)
            durationUnitMenuButton.setTitleColor(.black, for: .normal)
        }
        
        descriptionTextView.text = product.productDescription
        highlightsTextView.text = product.highlights
        
        // Update Counters
        nameCounterLabel.text = "\(product.name.count)/255"
        descriptionCounterLabel.text = "\(product.productDescription.count)"
        highlightsCounterLabel.text = "\(product.highlights.count)"
        
        // Images
        if let coverData = product.coverImage, let coverImg = UIImage(data: coverData) {
            updateSlotUI(index: 5, image: coverImg)
        }
        
        for (index, imageData) in product.galleryImages.enumerated() {
            if index < 5, let img = UIImage(data: imageData) {
                updateSlotUI(index: index, image: img)
            }
        }
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // Add padding to the bottom of scroll view so user can scroll to bottom-most fields
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height + 20, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func autoFillUserLocation() {
        if let email = UserDefaults.standard.string(forKey: "currentUserEmail"),
           let user = LocalDataManager.shared.fetchUser(email: email) {
            locationTextField.text = user.location
        }
    }
    
    private func setupUI() {
        // Ensure price field text alignment is consistent with the dropdown theme.
        priceTextField.textAlignment = .left
        priceTextField.setLeftPaddingPoints(12)
    }

    private func setupMenus() {
        // Category Menu
        let categories = ["Software", "Home Decors", "Electronics", "Furniture", "Fashion", "Other"]
        let catActions = categories.map { cat in
            UIAction(title: cat) { [weak self] _ in 
                self?.categoryMenuButton.setTitle(cat, for: .normal)
                self?.categoryMenuButton.setTitleColor(.black, for: .normal)
            }
        }
        categoryMenuButton.menu = UIMenu(title: "Select Category", children: catActions)
        categoryMenuButton.showsMenuAsPrimaryAction = true
        
        // Duration Unit Menu
        let durationUnits = ["Days", "Weeks", "Months"]
        let unitActions = durationUnits.map { unit in
            UIAction(title: unit) { [weak self] _ in 
                self?.durationUnitMenuButton.setTitle(unit, for: .normal)
                self?.durationUnitMenuButton.setTitleColor(.black, for: .normal)
                // Re-validate current number when unit changes
                self?.validateDuration()
            }
        }
        durationUnitMenuButton.menu = UIMenu(title: "Duration Unit", children: unitActions)
        durationUnitMenuButton.showsMenuAsPrimaryAction = true
    }
    
    private func validateDuration() {
        let unit = durationUnitMenuButton.title(for: .normal) ?? "Days"
        let currentText = durationNumberTextField.text ?? ""
        guard let value = Int(currentText) else { return }
        
        var maxLimit = 30
        if unit == "Weeks" {
            maxLimit = 4
        } else if unit == "Months" {
            maxLimit = 1
        }
        
        if value > maxLimit {
            durationNumberTextField.text = "\(maxLimit)"
        }
    }
    
    private func setupDelegates() {
        nameTextField.delegate = self
        durationNumberTextField.delegate = self
        descriptionTextView.delegate = self
        highlightsTextView.delegate = self
    }
    
    private func setupActions() {
        addProductButton.addTarget(self, action: #selector(didTapAddProduct), for: .touchUpInside)
    }
    
    @objc private func didTapBack() {
        // Check if any significant fields are filled to avoid unnecessary alerts
        let name = nameTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let hasImages = selectedImages.compactMap { $0 }.count > 0
        
        if !name.isEmpty || !location.isEmpty || !description.isEmpty || hasImages {
            let alert = UIAlertController(title: "Discard Changes?", message: "If you go back now, your product details will not be saved.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { [weak self] _ in
                self?.performBackNavigation()
            }))
            present(alert, animated: true)
        } else {
            performBackNavigation()
        }
    }
    
    private func performBackNavigation() {
        if navigationController?.viewControllers.count == 1 {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func clearFields() {
        nameTextField.text = ""
        locationTextField.text = ""
        categoryMenuButton.setTitle("Select Category", for: .normal)
        categoryMenuButton.setTitleColor(.lightGray, for: .normal)
        
        selectedImages = Array(repeating: nil, count: 6)
        imageSlotsStack.arrangedSubviews.compactMap { $0 as? UIImageView }.forEach {
            $0.image = UIImage(systemName: "plus")
            $0.contentMode = .center
            $0.layer.borderColor = UIColor.brandOrange.withAlphaComponent(0.4).cgColor
        }
        
        if let promoSlot = promotionSlot as? UIImageView {
            promoSlot.image = UIImage(systemName: "plus")
            promoSlot.contentMode = .center
            promoSlot.layer.borderColor = UIColor.brandOrange.cgColor
        }
        
        priceTextField.text = ""
        durationNumberTextField.text = ""
        durationUnitMenuButton.setTitle("Days", for: .normal)
        durationUnitMenuButton.setTitleColor(.lightGray, for: .normal)
        
        descriptionTextView.text = ""
        highlightsTextView.text = ""
        
        nameCounterLabel.text = "0/255"
        descriptionCounterLabel.text = "0"
        highlightsCounterLabel.text = "0"
        
        autoFillUserLocation()
    }
    
    // MARK: - UI Helpers
    
    private static func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.black
        ])
        attributedText.append(NSAttributedString(string: "*", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.red
        ]))
        label.attributedText = attributedText
        return label
    }
    
    private static func createSubTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.black
        ])
        attributedText.append(NSAttributedString(string: "*", attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.red
        ]))
        label.attributedText = attributedText
        return label
    }
    
    private static func createCounterLabel(limit: Int, isStatic: Bool = true) -> UILabel {
        let lbl = UILabel()
        lbl.text = isStatic ? "0/\(limit)" : "0"
        lbl.font = .systemFont(ofSize: 10) // Small enough to fit in the corner
        lbl.textColor = .lightGray
        lbl.textAlignment = .right
        return lbl
    }
    
    private func createStyledTextField(placeholder: String, icon: String? = nil) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = UIColor.brandOrange.cgColor
        tf.setLeftPaddingPoints(12)
        tf.font = .systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        if let iconName = icon {
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
            let iv = UIImageView(image: UIImage(systemName: iconName))
            iv.tintColor = .gray
            iv.contentMode = .scaleAspectFit
            iv.frame = CGRect(x: 5, y: 12.5, width: 20, height: 20)
            container.addSubview(iv)
            tf.rightView = container
            tf.rightViewMode = .always
        }
        
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        
        return tf
    }
    
    private func createMenuButton(placeholder: String, icon: String? = nil) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(placeholder, for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 35)
        
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.brandOrange.cgColor
        btn.backgroundColor = .white
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        if let iconName = icon {
            let iv = UIImageView(image: UIImage(systemName: iconName))
            iv.tintColor = .gray
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            btn.addSubview(iv)
            NSLayoutConstraint.activate([
                iv.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -10),
                iv.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
                iv.widthAnchor.constraint(equalToConstant: 20),
                iv.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        return btn
    }
    
    private func createLargeTextView(placeholder: String) -> UITextView {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1.0
        tv.layer.borderColor = UIColor.brandOrange.cgColor
        tv.font = .systemFont(ofSize: 14)
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 20, right: 8)
        tv.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        
        return tv
    }
    
    private func createPhotoSlot(index: Int, isLarge: Bool = false) -> UIImageView {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 10
        iv.layer.borderWidth = 1.0
        iv.layer.borderColor = UIColor.brandOrange.cgColor
        iv.contentMode = .center
        iv.image = UIImage(systemName: "plus")
        iv.tintColor = .gray
        iv.isUserInteractionEnabled = true
        iv.tag = index
        
        if !isLarge {
            iv.layer.borderColor = UIColor.brandOrange.withAlphaComponent(0.4).cgColor
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSlot(_:)))
        iv.addGestureRecognizer(tap)
        
        return iv
    }
    
    @objc private func didTapSlot(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        currentPickingIndex = tag
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private var currentPickingIndex: Int = 0
    
    // MARK: - Layout
    private func setupLayout() {
        let headerContainer = UIView()
        headerContainer.backgroundColor = .white
        headerContainer.addDropShadow(color: .black, opacity: 0.1, radius: 5, offset: CGSize(width: 0, height: 2))
        
        view.addSubview(headerContainer)
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(headerTitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Name Input Row
        let nameInputContainer = UIView()
        nameInputContainer.addSubview(nameTextField)
        nameInputContainer.addSubview(nameCounterLabel)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Promotion text stack
        let promoTextStack = UIStackView(arrangedSubviews: [promotionSubLabel, seeExampleButton])
        promoTextStack.axis = .vertical
        promoTextStack.alignment = .leading
        promoTextStack.spacing = 2
        
        let promoHorizontal = UIStackView(arrangedSubviews: [promotionSlot, promoTextStack])
        promoHorizontal.axis = .horizontal
        promoHorizontal.alignment = .center
        promoHorizontal.spacing = 15
        promotionSlot.translatesAutoresizingMaskIntoConstraints = false
        
        // Price Duration Container
        let priceStack = UIStackView(arrangedSubviews: [priceLabel, priceTextField])
        priceStack.axis = .horizontal
        priceStack.spacing = 8
        priceStack.alignment = .center
        
        let durationFieldsStack = UIStackView(arrangedSubviews: [durationNumberTextField, durationUnitMenuButton])
        durationFieldsStack.axis = .horizontal
        durationFieldsStack.spacing = 10
        durationFieldsStack.alignment = .center
        
        let durationStack = UIStackView(arrangedSubviews: [durationLabel, durationFieldsStack])
        durationStack.axis = .horizontal
        durationStack.spacing = 8
        durationStack.alignment = .center
        
        let priceDurationRow = UIStackView(arrangedSubviews: [priceStack, durationStack])
        priceDurationRow.axis = .vertical
        priceDurationRow.distribution = .fillProportionally
        priceDurationRow.spacing = 10
        
        // Large boxes with relative counters
        let descContainer = UIView()
        descContainer.addSubview(descriptionTextView)
        descContainer.addSubview(descriptionCounterLabel)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let highlightsContainer = UIView()
        highlightsContainer.addSubview(highlightsTextView)
        highlightsContainer.addSubview(highlightsCounterLabel)
        highlightsTextView.translatesAutoresizingMaskIntoConstraints = false
        highlightsCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [
            nameFieldTitle,
            nameInputContainer,
            locationFieldTitle,
            locationTextField,
            categoryFieldTitle,
            categoryMenuButton,
            productImagesTitle,
            imageSlotsStack,
            promotionTitle,
            promoHorizontal,
            priceDurationTitle,
            priceDurationRow,
            descriptionTitle,
            descContainer,
            highlightsTitle,
            highlightsContainer,
            addProductButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            backButton.centerYAnchor.constraint(equalTo: headerContainer.safeAreaLayoutGuide.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 15),
            
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerContainer.safeAreaLayoutGuide.centerYAnchor),
            headerTitleLabel.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            nameTextField.topAnchor.constraint(equalTo: nameInputContainer.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameInputContainer.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: nameInputContainer.trailingAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameInputContainer.bottomAnchor),
            nameCounterLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: -12),
            nameCounterLabel.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -5),
            
            imageSlotsStack.heightAnchor.constraint(equalToConstant: 65),
            promotionSlot.widthAnchor.constraint(equalToConstant: 70),
            promotionSlot.heightAnchor.constraint(equalToConstant: 70),
            
            priceDurationRow.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            priceTextField.widthAnchor.constraint(equalToConstant: 80),
            durationNumberTextField.widthAnchor.constraint(equalToConstant: 45),
            durationUnitMenuButton.widthAnchor.constraint(equalToConstant: 95),
            
            descriptionTextView.topAnchor.constraint(equalTo: descContainer.topAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: descContainer.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: descContainer.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: descContainer.bottomAnchor),
            descriptionCounterLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -12),
            descriptionCounterLabel.bottomAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: -8),
            
            highlightsTextView.topAnchor.constraint(equalTo: highlightsContainer.topAnchor),
            highlightsTextView.leadingAnchor.constraint(equalTo: highlightsContainer.leadingAnchor),
            highlightsTextView.trailingAnchor.constraint(equalTo: highlightsContainer.trailingAnchor),
            highlightsTextView.bottomAnchor.constraint(equalTo: highlightsContainer.bottomAnchor),
            highlightsCounterLabel.trailingAnchor.constraint(equalTo: highlightsTextView.trailingAnchor, constant: -12),
            highlightsCounterLabel.bottomAnchor.constraint(equalTo: highlightsTextView.bottomAnchor, constant: -8),
            
            addProductButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Delegates
    
    /// Limits the Product Name to 255 characters and updates the counter label in real-time.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Strictly enforce the 255 character limit as per database/design requirements.
            if updatedText.count <= 255 {
                nameCounterLabel.text = "\(updatedText.count)/255"
                return true
            }
            return false
        } else if textField == durationNumberTextField {
            // Only allow numbers
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // If empty, allow it (user might be deleting)
            if updatedText.isEmpty { return true }
            
            // Validate limit based on unit
            guard let value = Int(updatedText) else { return false }
            let unit = durationUnitMenuButton.title(for: .normal) ?? "Days"
            
            var maxLimit = 30
            if unit == "Weeks" {
                maxLimit = 4
            } else if unit == "Months" {
                maxLimit = 1
            }
            
            return value <= maxLimit
        }
        return true
    }
    
    /// Updates the dynamic counter for Description and Highlights as the user types.
    func textViewDidChange(_ textView: UITextView) {
        if textView == descriptionTextView {
            descriptionCounterLabel.text = "\(textView.text.count)"
        } else if textView == highlightsTextView {
            highlightsTextView.text = textView.text // Force update if needed
            highlightsCounterLabel.text = "\(textView.text.count)"
        }
    }
    
    /// Handles the image selection from the PHPicker and assigns it to the correct slot index.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self, let image = image as? UIImage else { return }
            
            DispatchQueue.main.async {
                // Sequential logic: filling the first empty slot
                if self.currentPickingIndex == 5 {
                    self.updateSlotUI(index: 5, image: image)
                } else {
                    if let firstEmptyIndex = self.selectedImages.prefix(5).firstIndex(where: { $0 == nil }) {
                        self.updateSlotUI(index: firstEmptyIndex, image: image)
                    } else {
                        // All filled? Replace specifically tapped index
                        self.updateSlotUI(index: self.currentPickingIndex, image: image)
                    }
                }
            }
        }
    }
    
    private func updateSlotUI(index: Int, image: UIImage) {
        self.selectedImages[index] = image
        if let slot = self.findSlot(for: index) as? UIImageView {
            slot.image = image
            slot.contentMode = .scaleAspectFill
            slot.clipsToBounds = true
            slot.layer.borderColor = UIColor.brandOrange.cgColor
        }
    }
    
    /// Helper to find the correct UIView based on the registered picking index.
    private func findSlot(for index: Int) -> UIView? {
        if index == 5 { return promotionSlot }
        return imageSlotsStack.arrangedSubviews[index]
    }
    
    // MARK: - Save Logics
    
    /// Collects all UI input data, validates types, and persists a new LocalProduct to SwiftData.
    @objc private func didTapAddProduct() {
        // 1. Basic Data Extraction
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let location = locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let category = categoryMenuButton.title(for: .normal) ?? ""
        let priceText = priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let durationNum = durationNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let durationUnit = durationUnitMenuButton.title(for: .normal) ?? ""
        let desc = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let highlights = highlightsTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // 2. Validation Logic
        
        // --- Text Fields ---
        if name.isEmpty || location.isEmpty || priceText.isEmpty || durationNum.isEmpty || desc.isEmpty || highlights.isEmpty {
            showAlert(title: "Missing Information", message: "All text fields are required. Please fill in all information.")
            return
        }
        
        // --- Category ---
        if category == "Select Category" || category.isEmpty {
            showAlert(title: "Select Category", message: "Please select a category for your product.")
            return
        }
        
        // --- Images ---
        let hasProductImage = selectedImages.prefix(5).contains { $0 != nil }
        let hasPromotionImage = selectedImages[5] != nil
        
        if !hasProductImage {
            showAlert(title: "Product Image", message: "Please add at least one product image.")
            return
        }
        
        if !hasPromotionImage {
            showAlert(title: "Promotion Image", message: "Please upload a buyer promotion image (white background).")
            return
        }
        
        // 3. Data Processing
        let price = Double(priceText) ?? 0.0
        let duration = "\(durationNum) \(durationUnit)"
        
        // Sequential collection: Priority to index 0.
        let mainImage = selectedImages.compactMap { $0 }.first
        let imageData = mainImage?.jpegData(compressionQuality: 0.8)
        
        // Get current user email
        let publisherEmail = UserDefaults.standard.string(forKey: "currentUserEmail")
        
        if let product = productToEdit {
            // Update existing product
            product.name = name
            product.location = location
            product.category = category
            product.price = price
            product.duration = duration
            product.productDescription = desc
            product.highlights = highlights
            product.coverImage = imageData
            // Gallery images update: Include ALL 6 slots (0-4 are product, 5 is promotion)
            let galleryImages = selectedImages.compactMap { $0?.jpegData(compressionQuality: 0.8) }
            product.galleryImages = galleryImages
            
            LocalDataManager.shared.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name("ProductsUpdated"), object: nil)
            showSuccess(message: "Product '\(name)' updated successfully!")
        } else {
            // Create the SwiftData model instance.
            let newProduct = LocalProduct(
                name: name,
                location: location,
                category: category,
                price: price,
                duration: duration,
                productDescription: desc,
                highlights: highlights,
                coverImage: imageData,
                publisherEmail: publisherEmail
            )
            
            // Collect gallery images: Include ALL 6 slots
            let galleryImages = selectedImages.compactMap { $0?.jpegData(compressionQuality: 0.8) }
            newProduct.galleryImages = galleryImages
            
            // Save to local container.
            LocalDataManager.shared.saveProduct(product: newProduct)
            NotificationCenter.default.post(name: NSNotification.Name("ProductsUpdated"), object: nil)
            showSuccess(message: "Product '\(name)' added successfully!")
        }
    }
    
    private func showSuccess(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.clearFields()
            self?.performBackNavigation()
        }))
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


import SwiftUI

struct AddProductView_Preview: PreviewProvider {
    static var previews: some View {
        AddProductViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}

struct AddProductViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AddProductViewController {
        return AddProductViewController()
    }
    
    func updateUIViewController(_ uiViewController: AddProductViewController, context: Context) {}
}

// MARK: - Dropdown Helper Extension
extension UITextField {
    func getMenu(title: String, items: [String], selection: @escaping (String) -> Void) -> UIMenu {
        let actions = items.map { item in
            UIAction(title: item) { _ in selection(item) }
        }
        return UIMenu(title: title, children: actions)
    }
}

