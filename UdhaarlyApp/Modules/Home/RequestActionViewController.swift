import UIKit
import PhotosUI

enum RequestActionMode {
    case returnProduct
    case reportDelay
}

class RequestActionViewController: UIViewController {
    
    private let mode: RequestActionMode
    private let request: LocalRequest
    var onComplete: (() -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // Commmon Components
    private let conditionLabel = UILabel()
    private let conditionTextView = UITextView()
    
    // Return Mode Components
    private let returnImageLabel = UILabel()
    private let returnImageView = UIImageView()
    
    // Delay Mode Components
    private let extendedTimeLabel = UILabel()
    private let extendedTimeField = UITextField()
    private let productInUseImageLabel = UILabel()
    private let productInUseImageView = UIImageView()
    private let paymentSlipImageLabel = UILabel()
    private let paymentSlipImageView = UIImageView()
    
    private let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    private var activeImagePicker: Int = 0 // 0: Return, 1: ProductInUse, 2: PaymentSlip
    
    init(mode: RequestActionMode, request: LocalRequest) {
        self.mode = mode
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        titleLabel.text = mode == .returnProduct ? "Return Product" : "Report Delay"
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        if mode == .reportDelay {
            let timeStack = createFormSection(title: "Extended Time (e.g., 5 Days)", subview: extendedTimeField)
            extendedTimeField.borderStyle = .roundedRect
            stackView.addArrangedSubview(timeStack)
        }
        
        let conditionStack = createFormSection(title: "Condition of Product", subview: conditionTextView)
        conditionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        conditionTextView.layer.borderWidth = 1
        conditionTextView.layer.cornerRadius = 8
        conditionTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.addArrangedSubview(conditionStack)
        
        if mode == .returnProduct {
            let imageStack = createFormSection(title: "Return Product Image", subview: returnImageView)
            setupImageView(returnImageView)
            stackView.addArrangedSubview(imageStack)
        } else {
            let usageImageStack = createFormSection(title: "Product In Use Image", subview: productInUseImageView)
            setupImageView(productInUseImageView)
            stackView.addArrangedSubview(usageImageStack)
            
            let slipImageStack = createFormSection(title: "Payment Slip Image", subview: paymentSlipImageView)
            setupImageView(paymentSlipImageView)
            stackView.addArrangedSubview(slipImageStack)
        }
        
        stackView.addArrangedSubview(submitButton)
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func createFormSection(title: String, subview: UIView) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        let stack = UIStackView(arrangedSubviews: [label, subview])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }
    
    private func setupImageView(_ iv: UIImageView) {
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 8
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let icon = UIImageView(image: UIImage(systemName: "plus.circle"))
        icon.tintColor = .brandOrange
        icon.translatesAutoresizingMaskIntoConstraints = false
        iv.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iv.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iv.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupActions() {
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        let returnTap = UITapGestureRecognizer(target: self, action: #selector(didTapReturnImage))
        returnImageView.addGestureRecognizer(returnTap)
        
        let usageTap = UITapGestureRecognizer(target: self, action: #selector(didTapUsageImage))
        productInUseImageView.addGestureRecognizer(usageTap)
        
        let slipTap = UITapGestureRecognizer(target: self, action: #selector(didTapSlipImage))
        paymentSlipImageView.addGestureRecognizer(slipTap)
    }
    
    @objc private func didTapReturnImage() { activeImagePicker = 0; presentPicker() }
    @objc private func didTapUsageImage() { activeImagePicker = 1; presentPicker() }
    @objc private func didTapSlipImage() { activeImagePicker = 2; presentPicker() }
    
    private func presentPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func submitTapped() {
        if mode == .returnProduct {
            guard let condition = conditionTextView.text, !condition.isEmpty,
                  let image = returnImageView.image?.jpegData(compressionQuality: 0.5) else {
                showAlert(message: "Please provide both condition and image.")
                return
            }
            LocalDataManager.shared.updateRequestReturn(request: request, condition: condition, image: image)
        } else {
            guard let time = extendedTimeField.text, !time.isEmpty,
                  let condition = conditionTextView.text, !condition.isEmpty,
                  let usageImg = productInUseImageView.image?.jpegData(compressionQuality: 0.5),
                  let slipImg = paymentSlipImageView.image?.jpegData(compressionQuality: 0.5) else {
                showAlert(message: "All fields and images are required.")
                return
            }
            LocalDataManager.shared.updateRequestDelay(request: request, extendedTime: time, condition: condition, productInUseImage: usageImg, paymentSlipImage: slipImg)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("RequestsUpdated"), object: nil)
        dismiss(animated: true) {
            self.onComplete?()
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension RequestActionViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                switch self?.activeImagePicker {
                case 0: self?.returnImageView.image = image
                case 1: self?.productInUseImageView.image = image
                case 2: self?.paymentSlipImageView.image = image
                default: break
                }
            }
        }
    }
}
