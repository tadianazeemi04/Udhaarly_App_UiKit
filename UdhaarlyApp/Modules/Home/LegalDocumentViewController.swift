//
//  LegalDocumentViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 08/04/2026.
//

import UIKit

class LegalDocumentViewController: UIViewController {
    
    // MARK: - Properties
    private let docType: LegalDocType
    private var isAgreed = false {
        didSet {
            updateAcceptButtonState()
        }
    }
    
    enum LegalDocType {
        case privacyPolicy
        case termsAndConditions
        
        var title: String {
            switch self {
            case .privacyPolicy: return "Privacy Policy"
            case .termsAndConditions: return "Terms & Conditions"
            }
        }
        
        var content: String {
            switch self {
            case .privacyPolicy: return LegalContent.privacyPolicy
            case .termsAndConditions: return LegalContent.termsAndConditions
            }
        }
    }
    
    // MARK: - UI Components
    private let headerView: GradientView = {
        let view = GradientView()
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.textColor = .darkGray
        tv.isEditable = false
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.showsVerticalScrollIndicator = true
        return tv
    }()
    
    private let footerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addDropShadow(color: .black, opacity: 0.1, radius: 10, offset: CGSize(width: 0, height: -5))
        return view
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = UIColor(hex: "#FF6700")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "I have read and agree to the terms"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept & Continue", for: .normal)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    init(type: LegalDocType) {
        self.docType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#F9F9F9")
        
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        
        view.addSubview(textView)
        view.addSubview(footerContainer)
        
        footerContainer.addSubview(checkboxButton)
        footerContainer.addSubview(agreementLabel)
        footerContainer.addSubview(acceptButton)
        
        titleLabel.text = docType.title
        textView.attributedText = formatLegalText(docType.content)
        
        checkPreviousAgreement()
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            textView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: footerContainer.topAnchor, constant: -10),
            
            footerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerContainer.heightAnchor.constraint(equalToConstant: 160),
            
            checkboxButton.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 15),
            checkboxButton.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor, constant: 20),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            agreementLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
            agreementLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 10),
            
            acceptButton.topAnchor.constraint(equalTo: checkboxButton.bottomAnchor, constant: 20),
            acceptButton.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor, constant: -20),
            acceptButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func formatLegalText(_ text: String) -> NSAttributedString {
        let fullAttributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray
        ])
        
        let lines = text.components(separatedBy: "\n")
        var currentOffset = 0
        
        for line in lines {
            let lineRange = NSRange(location: currentOffset, length: line.count)
            
            // Bold "Last Updated"
            if line.contains("Last Updated") {
                fullAttributedString.addAttributes([.font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.black], range: lineRange)
            }
            
            // Bold section headers (e.g., "1. INFORMATION", "2. HOW WE USE")
            let pattern = "^[0-9]+\\..*"
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.count)) != nil {
                fullAttributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.black], range: lineRange)
            }
            
            currentOffset += line.count + 1 // +1 for the newline
        }
        
        return fullAttributedString
    }
    
    private func checkPreviousAgreement() {
        let key = "hasAcceptedTerms_\(docType)"
        if UserDefaults.standard.bool(forKey: key) {
            isAgreed = true
            checkboxButton.isSelected = true
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        checkboxButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.addGestureRecognizer(labelTap)
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapCheckbox() {
        isAgreed.toggle()
        checkboxButton.isSelected = isAgreed
        
        // Haptic feedback
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    @objc private func didTapAccept() {
        // In a real app, you'd save this preference to a server or local storage
        UserDefaults.standard.set(true, forKey: "hasAcceptedTerms_\(docType)")
        navigationController?.popViewController(animated: true)
    }
    
    private func updateAcceptButtonState() {
        acceptButton.isEnabled = isAgreed
        acceptButton.backgroundColor = isAgreed ? UIColor(hex: "#FF6700") : .systemGray4
        
        // Animated transition
        UIView.animate(withDuration: 0.3) {
            self.acceptButton.transform = self.isAgreed ? CGAffineTransform(scaleX: 1.02, y: 1.02) : .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.acceptButton.transform = .identity
            }
        }
    }
}
