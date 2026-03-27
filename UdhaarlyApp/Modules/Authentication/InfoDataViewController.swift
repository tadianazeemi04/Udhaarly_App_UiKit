//
//  InfoDataViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 24/02/2026.
//

import UIKit
import PhotosUI

class InfoDataViewController: UIViewController {
    
    var userEmail: String?
    var userPassword: String?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var logoImageUI = UIImageView(image: UIImage(resource: .udhaarlyLogo))
    
    private var fewStepsText: UILabel = {
        let txt = UILabel()
        txt.text = "You are Just Few"
        txt.numberOfLines = 0
        txt.textAlignment = .center
        txt.font = .systemFont(ofSize: 40, weight: .bold)
        return txt
    }()
    private var StepsText: UILabel = {
        let txt = UILabel()
        txt.text = "Steps Away"
        txt.numberOfLines = 0
        txt.textAlignment = .center
        txt.font = .systemFont(ofSize: 40, weight: .bold)
        return txt
    }()
    
    
    private let profileImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Picture"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50 // Half of width/height
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()
    
    private let cameraContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .brandOrange
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let icon = UIImageView(image: UIImage(systemName: "camera.fill"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        return view
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
        
        // Disable auto-correction for name fields as requested.
        if label.contains("Name") {
            tf.autocorrectionType = .no
            tf.spellCheckingType = .no
        }
        
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
    
    private lazy var firstName = createLabeledField(label: "First Name", placeholder: "Enter your first name")
    private lazy var lastName = createLabeledField(label: "Last Name", placeholder: "Enter your last name")
    private lazy var yourLocation = createLabeledField(label: "Add Your Location", placeholder: "Search Location", icon: "mappin.and.ellipse")
    private lazy var phoneField = createLabeledField(label: "Phone Number", placeholder: "Enter your phone number", icon: "phone")
    private lazy var addressField = createLabeledField(label: "Address", placeholder: "Enter your detailed address", icon: "house")
    private lazy var dobField = createLabeledField(label: "Date of Birth", placeholder: "DD/MM/YYYY", icon: "calendar")
    
    private var startButtun: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Let's Get Started →", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.layer.cornerRadius = 12
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.addDropShadow(color: .brandOrange, opacity: 0.3, radius: 6, offset: CGSize(width: 0, height: 4))
        return btn
    }()
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageUI)
        contentView.addSubview(fewStepsText)
        contentView.addSubview(StepsText)
        contentView.addSubview(profileImageLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(cameraContainer)
        
        
        let stack = UIStackView(arrangedSubviews: [firstName, lastName, yourLocation, phoneField, addressField, dobField, startButtun])
        stack.axis = .vertical
        stack.spacing = 14
//        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
//        scrollView.backgroundColor = .systemYellow
//        contentView.backgroundColor = .systemCyan
        
        logoImageUI.contentMode = .scaleAspectFit
        logoImageUI.translatesAutoresizingMaskIntoConstraints = false
        fewStepsText.translatesAutoresizingMaskIntoConstraints = false
        StepsText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            logoImageUI.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            logoImageUI.heightAnchor.constraint(equalToConstant: 50),
            logoImageUI.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            fewStepsText.topAnchor.constraint(equalTo: logoImageUI.bottomAnchor, constant: 20),
            fewStepsText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            StepsText.topAnchor.constraint(equalTo: fewStepsText.bottomAnchor, constant: 0),
            StepsText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            profileImageLabel.topAnchor.constraint(equalTo: StepsText.bottomAnchor, constant: 20),
            profileImageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: profileImageLabel.bottomAnchor, constant: 10),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            cameraContainer.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -2),
            cameraContainer.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -2),
            
            stack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
//            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -30),
            
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private let dataPicker = UIDatePicker()
    private func setupDataPicker() {
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .wheels
        
        // Set date range limitations
        var components = DateComponents()
        components.year = 1960
        components.month = 1
        components.day = 1
        let minDate = Calendar.current.date(from: components)
        
        dataPicker.minimumDate = minDate
        dataPicker.maximumDate = Date() // Today's date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        if let stack = dobField as? UIStackView,
           let textField = stack.arrangedSubviews.last as? UITextField {
            textField.inputView = dataPicker
            textField.inputAccessoryView = toolbar
        }
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy"
        
        if let stack = dobField as? UIStackView,
           let textField = stack.arrangedSubviews.last as? UITextField {
            textField.text = formatter.string(from: dataPicker.date)
            validateFields()
        }
        view.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Registration", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func validateFields() {
        let fName = (firstName as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let lName = (lastName as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let loc = (yourLocation as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let phone = (phoneField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let addr = (addressField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let bday = (dobField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        
        let allFieldsFilled = !fName.isEmpty && !lName.isEmpty && !loc.isEmpty && !phone.isEmpty && !addr.isEmpty && !bday.isEmpty
        
        // Calculate age
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dataPicker.date, to: now)
        let age = ageComponents.year ?? 0
        let isAgeValid = age >= 16
        
        let isValid = allFieldsFilled && isAgeValid
        
        // Keep button enabled but visually distinguish it
        startButtun.alpha = isValid ? 1.0 : 0.7
    }
    
    @objc private func didTapStart() {
        // Validation logic
        let fName = (firstName as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let lName = (lastName as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let loc = (yourLocation as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let phone = (phoneField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let addr = (addressField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        let bday = (dobField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first?.text ?? ""
        
        // 1. Profile Picture Check
        let isDefaultImage = profileImageView.image == UIImage(systemName: "person.circle.fill")
        if isDefaultImage {
            showAlert(message: "Please upload a profile picture to continue.")
            return
        }
        
        // 2. Text Fields Check
        if fName.isEmpty || lName.isEmpty || loc.isEmpty || phone.isEmpty || addr.isEmpty || bday.isEmpty {
            showAlert(message: "All fields are required. Please fill in all information.")
            return
        }
        
        // 3. Age Restriction Check
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dataPicker.date, to: now)
        let age = ageComponents.year ?? 0
        
        if age < 16 {
            showAlert(message: "You must be at least 16 years old to use this app.")
            return
        }

        // Convert the current image in the view to Data
        let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5)
    
        guard let email = userEmail else { return }

        let newUser = LocalUser(
            email: self.userEmail ?? "",
            firstName: fName,
            lastName: lName,
            location: loc,
            phoneNumber: phone,
            address: addr,
            dob: bday,
            password: self.userPassword ?? "",
            profileImageData: imageData // Save the binary data here
        )
        
        // 4. Save to Local SwiftData Database
            LocalDataManager.shared.saveUser(user: newUser)
            
            // 5. Save Password Securely in Keychain (Local Machine encryption)
            if let password = userPassword {
                KeychainHelper.shared.save(password, account: email)
            }

            // 6. Finalize Registration locally
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(email, forKey: "currentUserEmail") // Persist for auto-fill logic
            
            /// Create a "Welcome to Udhaarly" notification to greet the new user.
            NotificationManager.shared.postNotification(
                title: "Welcome to Udhaarly! ✨",
                body: "Thank you for joining our community. Start lending and borrowing today!",
                recipientEmail: email,
                type: "system"
            )
        
            // Move to Main Tab Bar
            let tabBar = MainTabBarController()
            self.navigationController?.setViewControllers([tabBar], animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupKeyboardHiding()
        setupDataPicker()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(imageTap)
        
        startButtun.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        // Add targets for real-time validation
        [(firstName as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first,
         (lastName as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first,
         (yourLocation as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first,
         (phoneField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first,
         (addressField as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UITextField }.first].forEach {
            $0?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Initial validation check
        validateFields()
    }
    
}

//#Preview {
//    InfoDataViewController()
//}

extension InfoDataViewController: PHPickerViewControllerDelegate {
    
    @objc private func didTapProfileImage() {
        var config = PHPickerConfiguration()
        config.filter = .images // Only show photos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let image = image as? UIImage else { return }
            
            // Compress to stay around 1MB
            if image.jpegData(compressionQuality: 0.5) != nil {
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                    // Store this compressedData to save later
                }
            }
        }
    }
}
