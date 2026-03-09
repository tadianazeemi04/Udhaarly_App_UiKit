//
//  SignupViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 23/02/2026.
//

import UIKit

import UIKit

class SignupViewController: UIViewController {
    
    // UI Elements mapped to the new Card Layout
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return btn
    }()
    
    private var logoImageUI: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .udhaarlyLogo).withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        return imageView
    }()
    
    private let cardView: GradientCardView = {
        let v = GradientCardView()
        v.layer.cornerRadius = 24
        v.addDropShadow(color: .black, opacity: 0.1, radius: 10, offset: CGSize(width: 0, height: 5))
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private func createStyledTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        // tf.addDropShadow(color: .black, opacity: 0.05, radius: 4, offset: CGSize(width: 0, height: 2))
        return tf
    }
    
    private func createFieldTitle(text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 13, weight: .bold)
        return lbl
    }
    
    private lazy var emailTextField = createStyledTextField(placeholder: "Enter Email")
    
    private let emailErrorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Invalid email format"
        lbl.textColor = .systemRed // Resetting to visible colors for standard card background
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var passwordTextField = createStyledTextField(placeholder: "Enter Password")
    
    private let passwordLengthLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "✓ At least 6 characters"
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        return lbl
    }()
    
    private let passwordNumberLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "✓ Contains a number"
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        return lbl
    }()
    
    private lazy var confirmPasswordTextField = createStyledTextField(placeholder: "Confirm Password")
    
    /// Configures a password visibility toggle (eye icon) for a given text field.
    /// - Parameter textField: The target password field.
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
            
            if let text = textField.text, !text.isEmpty {
                textField.text = nil
                textField.text = text
            }
        }
    }
    
    // [Docs] validateFields() evaluates the email structure and password safety rules in real-time as the user types.
    @objc private func validateFields() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirm = confirmPasswordTextField.text ?? ""
        
        // --- Email Validation ---
        // [Docs] The Regex enforces standard email constraints (e.g. text@text.domain).
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        
        // [Docs] The error label is only shown (isHidden = false) if the email is invalid AND the user has started typing (not empty).
        emailErrorLabel.isHidden = isEmailValid || email.isEmpty
        if !email.isEmpty {
            emailTextField.layer.borderColor = isEmailValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        } else {
            emailTextField.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        }
        
        // --- Password Rules Validation ---
        // [Docs] Rule 1: Must be 6 or more characters.
        let hasLength = password.count >= 6
        // [Docs] Rule 2: Must contain at least one digit (0-9).
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        if !password.isEmpty {
            // [Docs] Dynamically change the helper bullet text colors based on whether each individual rule is currently satisfied.
            passwordLengthLabel.textColor = hasLength ? .systemGreen : .systemRed
            passwordNumberLabel.textColor = hasNumber ? .systemGreen : .systemRed
        } else {
            // [Docs] Reset to neutral gray when empty.
            passwordLengthLabel.textColor = .gray
            passwordNumberLabel.textColor = .gray
        }
        
        let isPasswordValid = hasLength && hasNumber
        
        // --- Confirm Password Match Validation ---
        // [Docs] The confirm field evaluates whether its text exactly matches the initial password text.
        if !confirm.isEmpty {
            if password != confirm {
                confirmPasswordTextField.layer.borderColor = UIColor.systemRed.cgColor
                passwordTextField.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            } else {
                // [Docs] If they match perfectly, we only grant them a 'Green' outline if the password itself is also secure (meets rules).
                let finalColor = isPasswordValid ? UIColor.systemGreen.cgColor : UIColor(white: 0.9, alpha: 1.0).cgColor
                confirmPasswordTextField.layer.borderColor = finalColor
                passwordTextField.layer.borderColor = finalColor
            }
        } else {
            confirmPasswordTextField.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            // Keep default until confirm password initiates
            passwordTextField.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        }
        
        // Update the Signup button state: only allow interaction if all fields are valid.
        let isMatch = !password.isEmpty && password == confirm && isPasswordValid && isEmailValid
        
        if isMatch {
            signupButton.isEnabled = true
            signupButton.alpha = 1
            signupButton.backgroundColor = .brandOrange
        } else {
            signupButton.isEnabled = false
            signupButton.alpha = 0.5
            signupButton.backgroundColor = .gray
        }
    }
    
    private let signupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.backgroundColor = .brandOrange // Bright orange button for primary action
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
    
    /// Creates a uniform social login button using assets found in Assets.xcassets.
    /// - Parameter imageName: The name of the logo asset (e.g. "google", "facebook").
    private func createSocialButton(imageName: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        // Fixed sizing ensures icons align perfectly in the horizontal social stack.
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return btn
    }
    
    private lazy var googleBtn = createSocialButton(imageName: "google")
    private lazy var facebookBtn = createSocialButton(imageName: "facebook")
    private lazy var appleBtn = createSocialButton(imageName: "apple-logo")
    
    private let loginPromptButton: UIButton = {
        let button = UIButton(type: .system)
        let mainText = "Already have an account? "
        let actionText = "Sign in"
        
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
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didtapSignup(){
        let signUp = OTPViewController()
        signUp.userEmail = emailTextField.text
        signUp.userPassword = passwordTextField.text
        navigationController?.pushViewController(signUp, animated: true)
    }
    
    @objc private func didTapSignin(){
        let signin = SigninViewController()
        navigationController?.pushViewController(signin, animated: true)
    }
    
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
    
    /// Sets up the hierarchical layout using UIStackViews for clean spacing and AutoLayout for responsiveness.
    private func setupLayout(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(backButton) // Keep back button stationary on top of scrollView
        contentView.addSubview(logoImageUI)
        contentView.addSubview(cardView)
        
        cardView.addSubview(welcomeText)
        
        let emailTitle = createFieldTitle(text: "E-mail Address")
        let emailStack = UIStackView(arrangedSubviews: [emailTitle, emailTextField, emailErrorLabel])
        emailStack.axis = .vertical
        emailStack.spacing = 6
        
        let passTitle = createFieldTitle(text: "Password")
        let rulesStack = UIStackView(arrangedSubviews: [passwordLengthLabel, passwordNumberLabel])
        rulesStack.axis = .vertical
        rulesStack.spacing = 4
        
        let passwordStack = UIStackView(arrangedSubviews: [passTitle, passwordTextField, rulesStack])
        passwordStack.axis = .vertical
        passwordStack.spacing = 6
        
        let confirmTitle = createFieldTitle(text: "Confirm Password")
        let confirmStack = UIStackView(arrangedSubviews: [confirmTitle, confirmPasswordTextField])
        confirmStack.axis = .vertical
        confirmStack.spacing = 6
        
        let socialStack = UIStackView(arrangedSubviews: [googleBtn, facebookBtn, appleBtn])
        socialStack.axis = .horizontal
        socialStack.spacing = 20
        socialStack.distribution = .equalSpacing
        
        // Main form stack containing all sections, buttons, and social logins.
        let stack = UIStackView(arrangedSubviews: [emailStack, passwordStack, confirmStack, signupButton, orLabel, socialStack, loginPromptButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)
        
        // Ensure standard fields take full width
        [emailStack, passwordStack, confirmStack, signupButton].forEach {
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
            // Crucial: The contentView width must match the scrollView width to disable horizontal scrolling.
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
    
    /// Configures the vibrant full-screen background gradient.
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss the keyboard when the user taps anywhere outside the text fields (Standard UX).
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Allow the user to dismiss the keyboard by simply scrolling down.
        scrollView.keyboardDismissMode = .onDrag
        
        setupGradientBackground()
        setupLayout()
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        setupPasswordToggle(for: passwordTextField)
        setupPasswordToggle(for: confirmPasswordTextField)
        
        passwordTextField.textContentType = .oneTimeCode
        confirmPasswordTextField.textContentType = .oneTimeCode

        passwordTextField.passwordRules = nil
        confirmPasswordTextField.passwordRules = nil
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.spellCheckingType = .no
        
        // Custom animated appearance
        animateEntry()
        
        signupButton.isEnabled = false
        signupButton.alpha = 0.5
        
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        
        signupButton.addTarget(self, action: #selector(didtapSignup), for: .touchUpInside)
        loginPromptButton.addTarget(self, action: #selector(didTapSignin), for: .touchUpInside)
        
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
        
        // Add content inset to the scroll view to lift the card contents above the keyboard.
        // This ensures the current text field is always visible and reachable.
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    /// Implements a smooth entry animation for the card and logo.
    private func animateEntry() {
        // Start with a slightly smaller scale and zero alpha for a "pop-in" effect.
        cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        cardView.alpha = 0
        
        // Slide the logo down from a slightly higher position.
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



#Preview{
    SignupViewController()
}
