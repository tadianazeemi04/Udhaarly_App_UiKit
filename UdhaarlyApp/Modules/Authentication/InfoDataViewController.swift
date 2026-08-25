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
    
    // MARK: - Country Definition
    private struct CountryItem {
        let name: String
        let code: String
        let flag: String
        let digitCount: Int
    }
    
    private let countries: [CountryItem] = [
        CountryItem(name: "Pakistan", code: "+92", flag: "🇵🇰", digitCount: 10),
        CountryItem(name: "United States", code: "+1", flag: "🇺🇸", digitCount: 10),
        CountryItem(name: "United Kingdom", code: "+44", flag: "🇬🇧", digitCount: 10),
        CountryItem(name: "United Arab Emirates", code: "+971", flag: "🇦🇪", digitCount: 9),
        CountryItem(name: "Saudi Arabia", code: "+966", flag: "🇸🇦", digitCount: 9),
        CountryItem(name: "Canada", code: "+1", flag: "🇨🇦", digitCount: 10),
        CountryItem(name: "Australia", code: "+61", flag: "🇦🇺", digitCount: 9),
        CountryItem(name: "India", code: "+91", flag: "🇮🇳", digitCount: 10),
        CountryItem(name: "Germany", code: "+49", flag: "🇩🇪", digitCount: 10),
        CountryItem(name: "Turkey", code: "+90", flag: "🇹🇷", digitCount: 10),
        CountryItem(name: "China", code: "+86", flag: "🇨🇳", digitCount: 11),
        CountryItem(name: "Malaysia", code: "+60", flag: "🇲🇾", digitCount: 9),
        CountryItem(name: "Qatar", code: "+974", flag: "🇶🇦", digitCount: 8),
        CountryItem(name: "Oman", code: "+968", flag: "🇴🇲", digitCount: 8),
        CountryItem(name: "Kuwait", code: "+965", flag: "🇰🇼", digitCount: 8)
    ]
    
    private var selectedCountry: CountryItem = CountryItem(name: "Pakistan", code: "+92", flag: "🇵🇰", digitCount: 10)
    
    // MARK: - App Locations List
    private let lahoreLocations = AppLocations.allLocations

    
    // MARK: - UI Components
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
        iv.layer.cornerRadius = 50
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
    
    // MARK: - Text Fields
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your first name"
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .words
        return tf
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your last name"
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .words
        return tf
    }()
    
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select Location"
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "300 1234567"
        tf.keyboardType = .numberPad
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your detailed address"
        tf.autocapitalizationType = .sentences
        return tf
    }()
    
    let dobTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "DD/MM/YYYY"
        return tf
    }()
    
    // Country Selector Button
    private lazy var countryCodeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("🇵🇰 +92 ▾", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.showsMenuAsPrimaryAction = true
        return btn
    }()
    
    // Pickers
    private let locationPicker = UIPickerView()
    private let dataPicker = UIDatePicker()
    
    private func createLabeledFieldContainer(label: String, textField: UITextField, icon: String? = nil, isPhone: Bool = false) -> UIView {
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
        
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.brandOrange.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.addDropShadow()
        
        if isPhone {
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 95, height: 50))
            countryCodeButton.frame = CGRect(x: 10, y: 0, width: 75, height: 50)
            
            let divider = UIView(frame: CGRect(x: 88, y: 12, width: 1.5, height: 26))
            divider.backgroundColor = UIColor.systemGray4
            
            container.addSubview(countryCodeButton)
            container.addSubview(divider)
            
            textField.leftView = container
            textField.leftViewMode = .always
        } else {
            textField.setLeftPaddingPoints(15)
        }
        
        if let iconName = icon {
            let iconView = UIImageView(image: UIImage(systemName: iconName))
            iconView.tintColor = .gray
            iconView.contentMode = .scaleAspectFit
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            iconView.frame = CGRect(x: 10, y: 5, width: 25, height: 20)
            container.addSubview(iconView)
            
            textField.rightView = container
            textField.rightViewMode = .always
        }
        
        let labelContainer = UIStackView(arrangedSubviews: [titleLabel, textField])
        labelContainer.axis = .vertical
        labelContainer.spacing = 8
        return labelContainer
    }
    
    private lazy var firstNameContainer = createLabeledFieldContainer(label: "First Name", textField: firstNameTextField)
    private lazy var lastNameContainer = createLabeledFieldContainer(label: "Last Name", textField: lastNameTextField)
    private lazy var locationContainer = createLabeledFieldContainer(label: "Add Your Location", textField: locationTextField, icon: "mappin.and.ellipse")
    private lazy var phoneContainer = createLabeledFieldContainer(label: "Phone Number", textField: phoneTextField, icon: "phone", isPhone: true)
    private lazy var addressContainer = createLabeledFieldContainer(label: "Address", textField: addressTextField, icon: "house")
    private lazy var dobContainer = createLabeledFieldContainer(label: "Date of Birth", textField: dobTextField, icon: "calendar")
    
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
    
    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageUI)
        contentView.addSubview(fewStepsText)
        contentView.addSubview(StepsText)
        contentView.addSubview(profileImageLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(cameraContainer)
        
        let stack = UIStackView(arrangedSubviews: [
            firstNameContainer,
            lastNameContainer,
            locationContainer,
            phoneContainer,
            addressContainer,
            dobContainer,
            startButtun
        ])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
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
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Country Menu Setup
    private func setupCountryMenu() {
        let actions = countries.map { [weak self] country in
            UIAction(title: "\(country.flag) \(country.name) (\(country.code))",
                     state: country.code == self?.selectedCountry.code ? .on : .off) { _ in
                guard let self = self else { return }
                self.selectedCountry = country
                self.countryCodeButton.setTitle("\(country.flag) \(country.code) ▾", for: .normal)
                self.setupCountryMenu()
                
                // Reformat existing text if present
                let rawDigits = (self.phoneTextField.text ?? "").filter { $0.isNumber }
                self.phoneTextField.text = self.formatPhoneNumber(raw: rawDigits, country: country)
                self.validateFields()
            }
        }
        countryCodeButton.menu = UIMenu(title: "Select Country", children: actions)
    }
    
    // MARK: - Phone Formatter
    private func formatPhoneNumber(raw: String, country: CountryItem) -> String {
        let digits = String(raw.filter { $0.isNumber }.prefix(country.digitCount))
        if country.code == "+92" {
            // Pakistan format: 300 1234567 (10 digits total)
            if digits.count > 3 {
                let index3 = digits.index(digits.startIndex, offsetBy: 3)
                let firstPart = String(digits[..<index3])
                let secondPart = String(digits[index3...])
                return "\(firstPart) \(secondPart)"
            }
            return digits
        } else if country.code == "+1" {
            // US/Canada: 300 123 4567
            if digits.count > 6 {
                let i3 = digits.index(digits.startIndex, offsetBy: 3)
                let i6 = digits.index(digits.startIndex, offsetBy: 6)
                return "\(digits[..<i3]) \(digits[i3..<i6]) \(digits[i6...])"
            } else if digits.count > 3 {
                let i3 = digits.index(digits.startIndex, offsetBy: 3)
                return "\(digits[..<i3]) \(digits[i3...])"
            }
            return digits
        } else {
            // General format: 3 digits space remainder
            if digits.count > 3 {
                let i3 = digits.index(digits.startIndex, offsetBy: 3)
                return "\(digits[..<i3]) \(digits[i3...])"
            }
            return digits
        }
    }
    
    // MARK: - Location Picker Setup
    private func setupLocationPicker() {
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(locationCancelPressed))
        cancelButton.tintColor = .brandOrange
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(locationDonePressed))
        doneButton.tintColor = .brandOrange
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        locationTextField.inputView = locationPicker
        locationTextField.inputAccessoryView = toolbar
    }
    
    @objc private func locationCancelPressed() {
        view.endEditing(true)
    }
    
    @objc private func locationDonePressed() {
        let selectedRow = locationPicker.selectedRow(inComponent: 0)
        if selectedRow >= 0 && selectedRow < lahoreLocations.count {
            locationTextField.text = lahoreLocations[selectedRow]
            validateFields()
        }
        view.endEditing(true)
    }
    
    // MARK: - Date of Birth Picker Setup
    private func setupDataPicker() {
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .wheels
        
        var components = DateComponents()
        components.year = 1960
        components.month = 1
        components.day = 1
        let minDate = Calendar.current.date(from: components)
        
        dataPicker.minimumDate = minDate
        dataPicker.maximumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(locationCancelPressed))
        cancelButton.tintColor = .brandOrange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        doneButton.tintColor = .brandOrange
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        dobTextField.inputView = dataPicker
        dobTextField.inputAccessoryView = toolbar
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy"
        
        dobTextField.text = formatter.string(from: dataPicker.date)
        validateFields()
        view.endEditing(true)
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Alerts
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Registration", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Real-time Validation
    @objc private func validateFields() {
        let fName = (firstNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lName = (lastNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let loc = (locationTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneDigits = (phoneTextField.text ?? "").filter { $0.isNumber }
        let addr = (addressTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let bday = (dobTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        let isFNameValid = !fName.isEmpty && fName.rangeOfCharacter(from: .decimalDigits) == nil
        let isLNameValid = !lName.isEmpty && lName.rangeOfCharacter(from: .decimalDigits) == nil
        let isLocValid = lahoreLocations.contains(loc)
        let isPhoneValid = phoneDigits.count == selectedCountry.digitCount
        let isAddrValid = !addr.isEmpty
        let isBdayValid = !bday.isEmpty
        
        // Calculate age
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dataPicker.date, to: now)
        let age = ageComponents.year ?? 0
        let isAgeValid = age >= 16 && isBdayValid
        
        let isValid = isFNameValid && isLNameValid && isLocValid && isPhoneValid && isAddrValid && isAgeValid
        
        startButtun.alpha = isValid ? 1.0 : 0.7
    }
    
    // MARK: - Submit / Registration Action
    @objc private func didTapStart() {
        let fName = (firstNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lName = (lastNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let loc = (locationTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneDigits = (phoneTextField.text ?? "").filter { $0.isNumber }
        let phoneFormatted = phoneTextField.text ?? ""
        let addr = (addressTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let bday = (dobTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. Profile Picture Check
        let isDefaultImage = profileImageView.image == UIImage(systemName: "person.circle.fill")
        if isDefaultImage {
            showAlert(message: "Please upload a profile picture to continue.")
            return
        }
        
        // 2. Name Checks (No numbers allowed)
        if fName.isEmpty || lName.isEmpty {
            showAlert(message: "Please enter both First Name and Last Name.")
            return
        }
        if fName.rangeOfCharacter(from: .decimalDigits) != nil || lName.rangeOfCharacter(from: .decimalDigits) != nil {
            showAlert(message: "First Name and Last Name must not contain any numbers.")
            return
        }
        
        // 3. Location Check (Restricted to Lahore locations)
        if loc.isEmpty || !lahoreLocations.contains(loc) {
            showAlert(message: "Please select a valid location from the provided list.")
            return
        }
        
        // 4. Phone Number Check
        if phoneDigits.count != selectedCountry.digitCount {
            showAlert(message: "Please enter a valid \(selectedCountry.digitCount)-digit phone number.")
            return
        }
        
        // 5. Address Check
        if addr.isEmpty {
            showAlert(message: "Please enter your detailed address.")
            return
        }
        
        // 6. Age Restriction Check
        if bday.isEmpty {
            showAlert(message: "Please select your date of birth.")
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dataPicker.date, to: now)
        let age = ageComponents.year ?? 0
        
        if age < 16 {
            showAlert(message: "You must be at least 16 years old to use this app.")
            return
        }

        // Full Phone Number with country code: e.g. +92 300 1234567
        let fullPhoneNumber = "\(selectedCountry.code) \(phoneFormatted)"

        // Convert the current image in the view to Data
        let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5)
    
        guard let email = userEmail else { return }

        let newUser = LocalUser(
            email: self.userEmail ?? "",
            firstName: fName,
            lastName: lName,
            location: loc,
            phoneNumber: fullPhoneNumber,
            address: addr,
            dob: bday,
            password: self.userPassword ?? "",
            profileImageData: imageData
        )
        
        // 4. Save to Local SwiftData Database
        LocalDataManager.shared.saveUser(user: newUser)
        
        // 5. Save Password Securely in Keychain
        if let password = userPassword {
            KeychainHelper.shared.save(password, account: email)
        }

        // 6. Finalize Registration locally
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.set(email, forKey: "currentUserEmail")
        
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupKeyboardHiding()
        setupLocationPicker()
        setupDataPicker()
        setupCountryMenu()
        
        // Set delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        locationTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        dobTextField.delegate = self
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(imageTap)
        
        startButtun.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        // Add editing targets for real-time validation
        [firstNameTextField, lastNameTextField, locationTextField, phoneTextField, addressTextField, dobTextField].forEach {
            $0.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Initial validation check
        validateFields()
    }
}

// MARK: - UITextFieldDelegate
extension InfoDataViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 1. First & Last Name: Disallow all numbers
        if textField == firstNameTextField || textField == lastNameTextField {
            if string.rangeOfCharacter(from: .decimalDigits) != nil {
                return false
            }
            return true
        }
        
        // 2. Location: Picked strictly via picker
        if textField == locationTextField {
            return false
        }
        
        // 3. Phone Field: Allow only digits and format automatically
        if textField == phoneTextField {
            if !string.isEmpty && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
                return false
            }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let digitsOnly = updatedText.filter { $0.isNumber }
            
            if digitsOnly.count > selectedCountry.digitCount {
                return false
            }
            
            textField.text = formatPhoneNumber(raw: digitsOnly, country: selectedCountry)
            validateFields()
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == locationTextField {
            if let currentText = locationTextField.text, let index = lahoreLocations.firstIndex(of: currentText) {
                locationPicker.selectRow(index, inComponent: 0, animated: false)
            } else {
                locationPicker.selectRow(0, inComponent: 0, animated: false)
                locationTextField.text = lahoreLocations[0]
                validateFields()
            }
        }
    }
}

// MARK: - UIPickerViewDelegate & DataSource (Location)
extension InfoDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lahoreLocations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lahoreLocations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        locationTextField.text = lahoreLocations[row]
        validateFields()
    }
}

// MARK: - PHPickerViewControllerDelegate (Profile Image)
extension InfoDataViewController: PHPickerViewControllerDelegate {
    
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
            guard let image = image as? UIImage else { return }
            
            if image.jpegData(compressionQuality: 0.5) != nil {
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                    self?.validateFields()
                }
            }
        }
    }
}
