import UIKit

class RequestsViewController: UIViewController {

    // MARK: - UI Components
    private let headerGradient: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
        view.layer.cornerRadius = 0 // Flat bottom for header
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
        label.text = "Requests"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let segmentContainer: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 12
        return sv
    }()

    private let borrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Borrow Request", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor(hex: "#FF5722")
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor(hex: "#FF5722").cgColor
        return button
    }()

    private let lendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lend Request", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.backgroundColor = .white
        button.setTitleColor(UIColor(hex: "#FF5722"), for: .normal)
        button.layer.borderColor = UIColor(hex: "#FF5722").cgColor
        return button
    }()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        return sv
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .center
        return sv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        showBorrowRequests() // Default view
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(headerGradient)
        headerGradient.addSubview(backButton)
        headerGradient.addSubview(navTitleLabel)
        
        view.addSubview(segmentContainer)
        segmentContainer.addArrangedSubview(borrowButton)
        segmentContainer.addArrangedSubview(lendButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            headerGradient.topAnchor.constraint(equalTo: view.topAnchor),
            headerGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerGradient.heightAnchor.constraint(equalToConstant: 110),

            backButton.bottomAnchor.constraint(equalTo: headerGradient.bottomAnchor, constant: -15),
            backButton.leadingAnchor.constraint(equalTo: headerGradient.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            navTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navTitleLabel.centerXAnchor.constraint(equalTo: headerGradient.centerXAnchor),

            segmentContainer.topAnchor.constraint(equalTo: headerGradient.bottomAnchor, constant: 15),
            segmentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            segmentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            segmentContainer.heightAnchor.constraint(equalToConstant: 45),

            scrollView.topAnchor.constraint(equalTo: segmentContainer.bottomAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -30)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        borrowButton.addTarget(self, action: #selector(borrowTapped), for: .touchUpInside)
        lendButton.addTarget(self, action: #selector(lendTapped), for: .touchUpInside)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func borrowTapped() {
        updateSegmentUI(isBorrow: true)
        showBorrowRequests()
    }

    @objc private func lendTapped() {
        updateSegmentUI(isBorrow: false)
        showLendRequests()
    }

    private func updateSegmentUI(isBorrow: Bool) {
        borrowButton.backgroundColor = isBorrow ? UIColor(hex: "#FF5722") : .white
        borrowButton.setTitleColor(isBorrow ? .white : UIColor(hex: "#FF5722"), for: .normal)
        
        lendButton.backgroundColor = isBorrow ? .white : UIColor(hex: "#FF5722")
        lendButton.setTitleColor(isBorrow ? UIColor(hex: "#FF5722") : .white, for: .normal)
    }

    private func showBorrowRequests() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let req1 = RequestCardView(name: "Ahamd bashir", phone: "03xxxxxxxxx", isBorrower: true)
        let req2 = RequestCardView(name: "Ahamd Ali", phone: "03xxxxxxxxx", isBorrower: true)
        
        stackView.addArrangedSubview(req1)
        stackView.addArrangedSubview(req2)
    }

    private func showLendRequests() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let req1 = RequestCardView(name: "Ali Hamid", phone: "03xxxxxxxxx", isBorrower: false)
        stackView.addArrangedSubview(req1)
    }
}
