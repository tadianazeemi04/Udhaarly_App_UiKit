//
//  EditProfileViewController.swift
//  UdhaarlyApp
//
//  Created by Antigravity on 24/03/2026.
//

import UIKit
import SwiftData
import PhotosUI

class EditProfileViewController: UIViewController, PHPickerViewControllerDelegate {

    // MARK: - Properties
    private var currentUser: LocalUser?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
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
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
        label.text = "Edit Profile"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let profileImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.isUserInteractionEnabled = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()

    private let cameraOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#FF5722")
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        
        let icon = UIImageView(image: UIImage(systemName: "camera.fill"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 16),
            icon.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        return view
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Changes", for: .normal)
        button.backgroundColor = UIColor(hex: "#FF5722")
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        return button
    }()

    private var emailField: (UIView, UITextField)?
    private var firstNameField: (UIView, UITextField)?
    private var lastNameField: (UIView, UITextField)?
    private var phoneField: (UIView, UITextField)?
    private var addressField: (UIView, UITextField)?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
        setupActions()
        setupKeyboardHandling()
    }

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerGradient)
        contentView.addSubview(backButton)
        contentView.addSubview(navTitleLabel)
        contentView.addSubview(profileImageContainer)
        profileImageContainer.addSubview(profileImageView)
        profileImageContainer.addSubview(cameraOverlayView)
        contentView.addSubview(stackView)
        
        // Create fields
        emailField = createEditableField(label: "Email (Non-editable)", placeholder: "", isEditable: false)
        firstNameField = createEditableField(label: "First Name", placeholder: "Enter first name")
        lastNameField = createEditableField(label: "Last Name", placeholder: "Enter last name")
        phoneField = createEditableField(label: "Phone Number", placeholder: "Enter phone number")
        addressField = createEditableField(label: "Address", placeholder: "Enter address")
        
        [emailField?.0, firstNameField?.0, lastNameField?.0, phoneField?.0, addressField?.0, saveButton].compactMap { $0 }.forEach {
            stackView.addArrangedSubview($0)
        }

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
            headerGradient.heightAnchor.constraint(equalToConstant: 220),

            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            navTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            profileImageContainer.topAnchor.constraint(equalTo: navTitleLabel.bottomAnchor, constant: 20),
            profileImageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageContainer.widthAnchor.constraint(equalToConstant: 100),
            profileImageContainer.heightAnchor.constraint(equalToConstant: 100),

            profileImageView.topAnchor.constraint(equalTo: profileImageContainer.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileImageContainer.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: profileImageContainer.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: profileImageContainer.bottomAnchor),

            cameraOverlayView.trailingAnchor.constraint(equalTo: profileImageContainer.trailingAnchor, constant: 0),
            cameraOverlayView.bottomAnchor.constraint(equalTo: profileImageContainer.bottomAnchor, constant: 0),
            cameraOverlayView.widthAnchor.constraint(equalToConstant: 30),
            cameraOverlayView.heightAnchor.constraint(equalToConstant: 30),

            stackView.topAnchor.constraint(equalTo: headerGradient.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createEditableField(label: String, placeholder: String, isEditable: Bool = true) -> (UIView, UITextField) {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .gray
        
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = .systemFont(ofSize: 16)
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(hex: "#F9FAFB")
        tf.layer.cornerRadius = 8
        tf.setLeftPaddingPoints(12)
        tf.isEnabled = isEditable
        if !isEditable {
            tf.textColor = .lightGray
            tf.backgroundColor = UIColor(hex: "#F3F4F6")
        }
        
        // Disable auto-correction for name fields as requested.
        if label.contains("Name") {
            tf.autocorrectionType = .no
            tf.spellCheckingType = .no
        }
        
        tf.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Add target to detect changes in real-time if needed, but we'll check on back press.
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(tf)
        
        return (container, tf)
    }

    private func hasUnsavedChanges() -> Bool {
        guard let user = currentUser else { return false }
        
        let currentFirstName = firstNameField?.1.text ?? ""
        let currentLastName = lastNameField?.1.text ?? ""
        let currentPhone = phoneField?.1.text ?? ""
        let currentAddress = addressField?.1.text ?? ""
        
        // Detect image change
        let isImageChanged = profileImageView.image?.jpegData(compressionQuality: 0.5) != user.profileImageData
        
        return currentFirstName != user.firstName ||
               currentLastName != user.lastName ||
               currentPhone != user.phoneNumber ||
               currentAddress != user.address ||
               isImageChanged
    }

    private func loadUserData() {
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        currentUser = LocalDataManager.shared.fetchUser(email: email)
        
        if let user = currentUser {
            emailField?.1.text = user.email
            firstNameField?.1.text = user.firstName
            lastNameField?.1.text = user.lastName
            phoneField?.1.text = user.phoneNumber
            addressField?.1.text = user.address
            
            if let imageData = user.profileImageData {
                profileImageView.image = UIImage(data: imageData)
            } else {
                profileImageView.image = UIImage(systemName: "person.circle.fill")
                profileImageView.tintColor = .white
            }
        }
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageContainer.addGestureRecognizer(imageTap)
    }

    @objc private func didTapProfileImage() {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self, let image = image as? UIImage else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }
    }

    @objc private func backTapped() {
        if hasUnsavedChanges() {
            let alert = UIAlertController(
                title: "Unsaved Changes",
                message: "You have unsaved changes. Are you sure you want to discard them and go back?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func saveTapped() {
        guard let user = currentUser else { return }
        
        // Basic validation
        let firstName = firstNameField?.1.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let lastName = lastNameField?.1.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if firstName.isEmpty || lastName.isEmpty {
            let alert = UIAlertController(title: "Error", message: "First and Last names cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        user.firstName = firstName
        user.lastName = lastName
        user.phoneNumber = phoneField?.1.text ?? ""
        user.address = addressField?.1.text ?? ""
        
        // Save new profile image
        if let newImage = profileImageView.image {
            user.profileImageData = newImage.jpegData(compressionQuality: 0.5)
        }
        
        LocalDataManager.shared.saveContext()
        
        let alert = UIAlertController(title: "Profile Updated", message: "Your data has been updated and saved successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
