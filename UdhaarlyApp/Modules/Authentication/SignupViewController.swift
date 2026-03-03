//
//  SignupViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 23/02/2026.
//

import UIKit

class SignupViewController: UIViewController {
    
    private var logoImageUI = UIImageView(image: UIImage(resource: .udhaarlyLogo))
    private let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Udhaarly😊"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let joinUsText: UILabel = {
        let label1 = UILabel()
        label1.text = "Join US"
        label1.font = .systemFont(ofSize: 26, weight: .bold)
        label1.textColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0)
        return label1
    }()
    
    private func createStyledTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0).cgColor
        tf.setLeftPaddingPoints(15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }
    
    private lazy var emailTextField = createStyledTextField(placeholder: "Enter Email")
    private lazy var passwordTextField = createStyledTextField(placeholder: "Enter Password")
    private lazy var confirmPasswordTextField = createStyledTextField(placeholder: "Confirm Password")
    
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
    
    @objc private func validateFields() {
        let password = passwordTextField.text ?? ""
        let confirm = confirmPasswordTextField.text ?? ""
        
        if !confirm.isEmpty && password != confirm {
                confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                confirmPasswordTextField.layer.borderColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0).cgColor
            }
        
        let isMatch = !password.isEmpty && password == confirm && password.count >= 6
        if isMatch {
            signupButton.isEnabled = true
            signupButton.alpha = 1
            signupButton.backgroundColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0)
        } else {
            signupButton.isEnabled = false
            signupButton.alpha = 0.5
            signupButton.backgroundColor = .gray
        }
    }
    
    private let signupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.backgroundColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0)
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    @objc private func didtapSignup(){
        
        let nextVC = InfoDataViewController()
            
            // Pass the data forward
        nextVC.userEmail = emailTextField.text
        nextVC.userPassword = passwordTextField.text
        
        let signUp = OTPViewController()
        navigationController?.pushViewController(signUp, animated: true)
    }
    
    @objc private func didTapSignin(){
        let signin = SigninViewController()
        navigationController?.pushViewController(signin, animated: true)
    }
    
    private let loginPromptButton: UIButton = {
        let button = UIButton(type: .system)
        let mainText = "Already have an account? "
        let actionText = "Sign in here"
        
        let attributedString = NSMutableAttributedString(string: mainText, attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14)
        ])
        
        attributedString.append(NSAttributedString(string: actionText, attributes: [
            .foregroundColor: UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
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
    
    private func setupLayout(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageUI)
        contentView.addSubview(welcomeText)
        contentView.addSubview(joinUsText)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,confirmPasswordTextField,signupButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        contentView.addSubview(loginPromptButton)
        loginPromptButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageUI.translatesAutoresizingMaskIntoConstraints = false
        welcomeText.translatesAutoresizingMaskIntoConstraints = false
        joinUsText.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            logoImageUI.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageUI.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageUI.widthAnchor.constraint(equalToConstant: 250),
                
            // This tells the height to follow the width based on the image's actual size
            logoImageUI.heightAnchor.constraint(equalTo: logoImageUI.widthAnchor, multiplier: (logoImageUI.image?.size.height ?? 1) / (logoImageUI.image?.size.width ?? 1)),
            
            welcomeText.topAnchor.constraint(equalTo: logoImageUI.bottomAnchor, constant: 20),
            welcomeText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            joinUsText.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 20),
            joinUsText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stack.topAnchor.constraint(equalTo: joinUsText.bottomAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            loginPromptButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 4),
            loginPromptButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            loginPromptButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        scrollView.keyboardDismissMode = .onDrag
        
        view.backgroundColor = .white
        setupLayout()
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        setupPasswordToggle(for: passwordTextField)
        setupPasswordToggle(for: confirmPasswordTextField)
        
        passwordTextField.textContentType = .oneTimeCode
        confirmPasswordTextField.textContentType = .oneTimeCode

        // 2. Disable the "Strong Password" suggestion specifically
        passwordTextField.passwordRules = nil
        confirmPasswordTextField.passwordRules = nil
        
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
        
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.spellCheckingType = .no
        
        signupButton.isEnabled = false
        signupButton.alpha = 0.5
        signupButton.backgroundColor = .gray
        
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        signupButton.addTarget(self, action: #selector(didtapSignup), for: .touchUpInside)
        
        loginPromptButton.addTarget(self, action: #selector(didTapSignin), for: .touchUpInside)
    }
    
}



#Preview{
    SignupViewController()
}
