//
//  OTPViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 25/02/2026.
//

import UIKit

class OTPViewController: UIViewController {
    
    private var logoImageUI = UIImageView(image: UIImage(resource: .udhaarlyLogo))
    private var OtpText: UILabel = {
        let label = UILabel()
        label.text = "Enter 6-digit OTP"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private func createStyledOtpBoxField(placholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placholder
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0).cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf .heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }
    
    private var otpFields: [UITextField] = []
    
    private var verifyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Verify", for: .normal)
        btn.isEnabled = false
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.backgroundColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private func setupOTPFields(){
        for _ in 0...5 {
            let tf = UITextField()
            tf.layer.cornerRadius = 10
            tf.layer.borderWidth = 3
            tf.layer.borderColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0).cgColor
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf .heightAnchor.constraint(equalToConstant: 50).isActive = true
            tf .widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            tf.delegate = self
            tf.keyboardType = .numberPad
            tf.textAlignment = .center
            tf.font = .systemFont(ofSize: 24, weight: .bold)
            
            otpFields.append(tf)
        }
    }
    
    private func validateOtpBox() {
        let isComplete = otpFields.allSatisfy { $0.text?.count == 1 }
            
        if isComplete {
            verifyButton.isEnabled = true
            verifyButton.backgroundColor = UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0)
        } else {
            verifyButton.isEnabled = false
            verifyButton.backgroundColor = .systemGray4
        }
    }
    
    private var timer: Timer?
    private var remainingSeconds = 60
    
    private let resendStaticLabel: UILabel = {
        let label = UILabel()
        label.text = "Didn’t receive OTP? "
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private let resendActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        // Start with the initial state
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    private func updateResendUI() {
        if remainingSeconds > 0 {
            resendActionButton.setTitle("Resend in \(remainingSeconds)s", for: .normal)
            resendActionButton.setTitleColor(.gray, for: .normal)
            resendActionButton.isEnabled = false
        } else {
            resendActionButton.setTitle("Resend OTP", for: .normal)
            resendActionButton.setTitleColor(UIColor(red: 0.95, green: 0.42, blue: 0.21, alpha: 1.0), for: .normal)
            resendActionButton.isEnabled = true
        }
    }
    
    
        
    private func startTimer() {
            remainingSeconds = 60
            updateResendUI() // Set initial "Resend in 60s"
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                    self.updateResendUI()
                } else {
                    self.timer?.invalidate()
                    self.updateResendUI()
                }
            }
    }
    
    private func setupResendFooter() {
            let footerStack = UIStackView(arrangedSubviews: [resendStaticLabel, resendActionButton])
            footerStack.axis = .horizontal
            footerStack.spacing = 5 // Small gap between the question and the button
            footerStack.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(footerStack)
            
            NSLayoutConstraint.activate([
                footerStack.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
                footerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            resendActionButton.addTarget(self, action: #selector(didTapResend), for: .touchUpInside)
        }
        
    @objc private func didTapResend() {
        print("Resending OTP...")
        // Call your backend/API to send a new code here
        startTimer() // Restart the countdown
    }
    
    @objc private func didTapVerify(){
        let verify = InfoDataViewController()
        navigationController?.pushViewController(verify, animated: true)
    }
    
    private func setUpLayout(){
        let otpStackView = UIStackView(arrangedSubviews: otpFields)
        otpStackView.axis = .horizontal
        otpStackView.distribution = .equalSpacing
        otpStackView.spacing = 8
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageUI)
        view.addSubview(OtpText)
        view.addSubview(otpStackView)
        view.addSubview(verifyButton)
        
        setupResendFooter()
        
        logoImageUI.translatesAutoresizingMaskIntoConstraints = false
        logoImageUI.contentMode = .scaleAspectFit
        OtpText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageUI.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageUI.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageUI.heightAnchor.constraint(equalToConstant: 60),
            logoImageUI.widthAnchor.constraint(equalToConstant: 250),
            
            OtpText.topAnchor.constraint(equalTo: logoImageUI.bottomAnchor, constant: 40),
            OtpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            otpStackView.topAnchor.constraint(equalTo: OtpText.bottomAnchor, constant: 30),
            otpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            verifyButton.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 20),
            verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            verifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            verifyButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupOTPFields()
        setUpLayout()
        startTimer()
        
        verifyButton.addTarget(self, action: #selector(didTapVerify), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
}

#Preview{
    OTPViewController()
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Handle Backspace (Delete)
        if string.isEmpty {
            textField.text = ""
            // Jump BACKWARDS: if index > 0
            if let index = otpFields.firstIndex(of: textField), index > 0 {
                otpFields[index - 1].becomeFirstResponder()
            }
            validateOtpBox()
            return false
        }
        
        // Numeric check
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }
                
        // Handle single digit input
        if string.count == 1 {
            textField.text = string
            // Jump FORWARDS: if index < 5
            if let index = otpFields.firstIndex(of: textField), index < 5 {
                otpFields[index + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder() // Hide keyboard on last box
            }
            validateOtpBox()
            return false
        }
        return false
    }
}


