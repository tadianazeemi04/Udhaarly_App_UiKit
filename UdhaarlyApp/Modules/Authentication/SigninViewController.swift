//
//  SigninViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 25/02/2026.
//

import UIKit

class SigninViewController: UIViewController {
    
    private var logoImageUI = UIImageView(image: UIImage(resource: .udhaarlyLogo))
    private let welcomeBackText: UILabel = {
        let label = UILabel()
        label.text = "Welcome back to Udhaarly👋🏻"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let SignInText: UILabel = {
        let label1 = UILabel()
        label1.text = "Sign in"
        label1.font = .systemFont(ofSize: 26, weight: .bold)
        label1.textColor = .brandOrange
        return label1
    }()
    
    private func createStyledTextField(placeholder: String)-> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.brandOrange.cgColor
        tf.setLeftPaddingPoints(15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.addDropShadow()
        return tf
    }
    
    private lazy var emailTextField = createStyledTextField(placeholder: "Enter Email")
    private lazy var passwordTextField = createStyledTextField(placeholder: "Enter Password")
    
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
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let validationCondition = email.contains("@") && !email.isEmpty && !password.isEmpty && password.count >= 6
        if validationCondition {
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
        btn.setTitle("Sign in", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.addDropShadow(color: .brandOrange, opacity: 0.3, radius: 6, offset: CGSize(width: 0, height: 4))
        return btn
    }()
    
    private let signupPromptButton: UIButton = {
        let button = UIButton(type: .system)
        let mainText = "Don't have an account? "
        let actionText = "Sign up here"
        
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
        contentView.addSubview(welcomeBackText)
        contentView.addSubview(SignInText)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,signinButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        contentView.addSubview(signupPromptButton)
        signupPromptButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageUI.translatesAutoresizingMaskIntoConstraints = false
        welcomeBackText.translatesAutoresizingMaskIntoConstraints = false
        SignInText.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            welcomeBackText.topAnchor.constraint(equalTo: logoImageUI.bottomAnchor, constant: 20),
            welcomeBackText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            SignInText.topAnchor.constraint(equalTo: welcomeBackText.bottomAnchor, constant: 20),
            SignInText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stack.topAnchor.constraint(equalTo: SignInText.bottomAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            signupPromptButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 4),
            signupPromptButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            signupPromptButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func didtapSignup(){
//        let signUp = SignupViewController()
        navigationController?.popViewController( animated: true)
    }
    
    @objc private func didTapSignin(){
        let signin = OTPViewController()
        navigationController?.pushViewController(signin, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        scrollView.keyboardDismissMode = .onDrag
        
        view.backgroundColor = .systemBackground
        setupLayout()
        
        passwordTextField.isSecureTextEntry = true
        
        setupPasswordToggle(for: passwordTextField)
        
        passwordTextField.textContentType = .oneTimeCode

        // 2. Disable the "Strong Password" suggestion specifically
        passwordTextField.passwordRules = nil
        
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
        
        signinButton.isEnabled = false
        signinButton.alpha = 0.5
        signinButton.backgroundColor = .gray
        
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)

        signinButton.addTarget(self, action: #selector(didTapSignin), for: .touchUpInside)
        
        signupPromptButton.addTarget(self, action: #selector(didtapSignup), for: .touchUpInside)
        
    }

}

#Preview {
    SigninViewController()
}
