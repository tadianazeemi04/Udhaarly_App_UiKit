//
//  SigninViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 25/02/2026.
//

import UIKit

class SigninViewController: UIViewController {
    
    // MARK: - UI Configuration
    
    /// A custom back button with a bold chevron.
    /// This is placed on the background layer, above the scroll view, to remain fixed during scrolling.
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return btn
    }()
    
    /// The main Udhaarly logo, updated to use template rendering so its color can be controlled via code.
    private var logoImageUI: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .udhaarlyLogo).withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        return imageView
    }()
    
    /// The central floating card container that holds the sign-in form.
    /// Uses a custom gradient background and a soft shadow for a "glassmorphism" feel.
    private let cardView: GradientCardView = {
        let v = GradientCardView()
        v.layer.cornerRadius = 24
        v.addDropShadow(color: .black, opacity: 0.1, radius: 10, offset: CGSize(width: 0, height: 5))
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome back"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    /// Helper to create consistent, pill-styled text fields used across the app.
    private func createStyledTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.layer.borderWidth = 1.0
        // Light gray border that turns green/red during validation.
        tf.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        return tf
    }
    
    /// Helper to create small, bold titles above each input field.
    private func createFieldTitle(text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 13, weight: .bold)
        return lbl
    }
    
    private lazy var emailTextField = createStyledTextField(placeholder: "Enter Email")
    
    /// Error label that appears below the email field if the format is invalid.
    private let emailErrorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Invalid email format"
        lbl.textColor = .systemRed
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var passwordTextField = createStyledTextField(placeholder: "Enter Password")
    
    /// Configures the "eye" icon toggle for password fields.
    private func setupPasswordToggle(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        button.center = container.center
        container.addSubview(button)
        textField.rightView = container
        textField.rightViewMode = .always
        
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        if let container = sender.superview, let textField = container.superview as? UITextField {
            textField.isSecureTextEntry.toggle()
            // Resetting text prevents a minor UIKit bug where the font changes during toggle.
            if let text = textField.text, !text.isEmpty {
                textField.text = nil
                textField.text = text
            }
        }
    }
    
    // MARK: - Validation Logic
    
    /// Real-time field validation to provide immediate visual feedback.
    /// Matches the exact Email Regex rules used in SignupViewController.
    @objc private func validateFields() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // --- Email Validation ---
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        
        // Show/hide error label and change border color dynamically.
        emailErrorLabel.isHidden = isEmailValid || email.isEmpty
        if !email.isEmpty {
            emailTextField.layer.borderColor = isEmailValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        } else {
            emailTextField.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        }
        
        // Enable Sign-in button only if email is valid and password meets minimum length.
        let isValid = isEmailValid && password.count >= 6
        
        if isValid {
            signinButton.isEnabled = true
            signinButton.alpha = 1
            signinButton.backgroundColor = .brandOrange
        } else {
            signinButton.isEnabled = false
            signinButton.alpha = 0.5
            signinButton.backgroundColor = .gray
        }
    }
    
    private let signinButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign In", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.layer.cornerRadius = 12
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    /// Creates a consistent social authentication button.
    private func createSocialButton(imageName: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return btn
    }
    
    private lazy var googleBtn = createSocialButton(imageName: "google")
    private lazy var facebookBtn = createSocialButton(imageName: "facebook")
    private lazy var appleBtn = createSocialButton(imageName: "apple-logo")
    
    private let signupPromptButton: UIButton = {
        let button = UIButton(type: .system)
        let mainText = "Don't have an account? "
        let actionText = "Sign up"
        
        let attributedString = NSMutableAttributedString(string: mainText, attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14)
        ])
        
        attributedString.append(NSAttributedString(string: actionText, attributes: [
            .foregroundColor: UIColor.brandOrange,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    // MARK: - Navigation Logic
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSignup() {
        // Going back to the Signup view (which is likely the root or previous screen).
        navigationController?.popViewController(animated: true)
    }
    
    /// Handles the primary authentication flow securely.
    @objc private func didTapSignin() {
        guard let email = emailTextField.text, let enteredPassword = passwordTextField.text else { return }
        
        // ADMIN BYPASS: Custom credentials for dashboard access
        if email == "admin123@admin.com", enteredPassword == "admin123" {
            let adminVC = AdminViewController()
            // Using a cross-dissolve or push depending on preference, here we replace to stay in the stack comfortably.
            navigationController?.setViewControllers([adminVC], animated: true)
            return
        }
        
        // 1. Match Check: Retrieve the encrypted password from Keychain for this email.
        if let storedPassword = KeychainHelper.shared.read(account: email) {
            if enteredPassword == storedPassword {
                // SUCCESS: Credentials match local records.
                
                // 2. Profile Check: Check if a full user profile exists in SwiftData.
                if let _ = LocalDataManager.shared.fetchUser(email: email) {
                    // Profile exists: Returning user.
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.set(email, forKey: "currentUserEmail")
                    
                    /// Create a "Welcome Back" notification to log the successful login event.
                    NotificationManager.shared.postNotification(
                        title: "Welcome Back! 👋",
                        body: "You have successfully logged into your Udhaarly account.",
                        recipientEmail: email,
                        type: "system"
                    )
                    
                    let tabBar = MainTabBarController()
                    navigationController?.setViewControllers([tabBar], animated: true)
                } else {
                    // Profile missing: Credential-only user (e.g. registered but didn't finish Info setup).
                    // Navigate to InfoData to complete registration.
                    let infoVC = InfoDataViewController()
                    infoVC.userEmail = email
                    infoVC.userPassword = enteredPassword
                    navigationController?.pushViewController(infoVC, animated: true)
                }
            } else {
                // FAILURE: Password does not match Keychain record.
                showAlert(message: "Incorrect password. Please try again.")
            }
        } else {
            // FAILURE: No data found for this email in Keychain.
            showAlert(message: "No account found for this email. Would you like to sign up?")
        }
    }
    
    /// Helper to show standard iOS alerts for error messaging.
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Sign In", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Layout & Constraints
    
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
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(backButton)
        contentView.addSubview(logoImageUI)
        contentView.addSubview(cardView)
        
        cardView.addSubview(welcomeText)
        
        // Organize inputs into vertical stacks for easy spacing management.
        let emailTitle = createFieldTitle(text: "E-mail Address")
        let emailStack = UIStackView(arrangedSubviews: [emailTitle, emailTextField, emailErrorLabel])
        emailStack.axis = .vertical
        emailStack.spacing = 6
        
        let passTitle = createFieldTitle(text: "Password")
        let passwordStack = UIStackView(arrangedSubviews: [passTitle, passwordTextField])
        passwordStack.axis = .vertical
        passwordStack.spacing = 6
        
        let socialStack = UIStackView(arrangedSubviews: [googleBtn, facebookBtn, appleBtn])
        socialStack.axis = .horizontal
        socialStack.spacing = 20
        socialStack.distribution = .equalSpacing
        
        let stack = UIStackView(arrangedSubviews: [emailStack, passwordStack, signinButton, orLabel, socialStack, signupPromptButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)
        
        // Ensure inputs fill the full width of the main stack.
        [emailStack, passwordStack, signinButton].forEach {
            $0.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        }
        
        logoImageUI.translatesAutoresizingMaskIntoConstraints = false
        welcomeText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            logoImageUI.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            logoImageUI.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageUI.widthAnchor.constraint(equalToConstant: 200),
            logoImageUI.heightAnchor.constraint(equalTo: logoImageUI.widthAnchor, multiplier: (logoImageUI.image?.size.height ?? 1) / (logoImageUI.image?.size.width ?? 1)),
            
            cardView.topAnchor.constraint(equalTo: logoImageUI.bottomAnchor, constant: 30),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            welcomeText.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            welcomeText.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            stack.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -40)
        ])
    }
    
    /// Configures the vibrant orange-to-red background gradient.
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 0.96, green: 0.16, blue: 0.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        scrollView.keyboardDismissMode = .onDrag
        
        setupGradientBackground()
        setupLayout()
        
        passwordTextField.isSecureTextEntry = true
        setupPasswordToggle(for: passwordTextField)
        
        // Disable suggestions that might interfere with manual login data.
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
        
        animateEntry()
        
        signinButton.isEnabled = false
        signinButton.alpha = 0.5
        
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        
        signinButton.addTarget(self, action: #selector(didTapSignin), for: .touchUpInside)
        signupPromptButton.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
        
        setupKeyboardObservers()
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Animations
    
    /// Implements a smooth "pop-in" animation for the logo and card.
    private func animateEntry() {
        cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        cardView.alpha = 0
        logoImageUI.transform = CGAffineTransform(translationX: 0, y: -20)
        logoImageUI.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.cardView.transform = .identity
            self.cardView.alpha = 1
            self.logoImageUI.transform = .identity
            self.logoImageUI.alpha = 1
        })
    }
}


#Preview {
    SigninViewController()
}
