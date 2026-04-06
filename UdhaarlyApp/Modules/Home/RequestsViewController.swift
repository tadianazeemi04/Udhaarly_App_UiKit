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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if borrowButton.backgroundColor == UIColor(hex: "#FF5722") {
            showBorrowRequests()
        } else {
            showLendRequests()
        }
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
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -50)
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
        
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        let requests = LocalDataManager.shared.fetchRequests(forEmail: currentUserEmail, isLender: false)
        
        if requests.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No borrow requests found."
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = .center
            emptyLabel.font = .systemFont(ofSize: 16)
            stackView.addArrangedSubview(emptyLabel)
            return
        }

        for request in requests {
            let card = RequestCardView(request: request, isLender: false)
            card.onCancel = { [weak self] in
                self?.handleCancel(request: request)
            }
            card.onReturn = { [weak self] in
                self?.presentActionVC(mode: .returnProduct, request: request)
            }
            card.onDelay = { [weak self] in
                self?.presentActionVC(mode: .reportDelay, request: request)
            }
            card.onRateUser = { [weak self] in
                self?.presentReviewInput(request: request, isLender: false)
            }
            stackView.addArrangedSubview(card)
        }
    }

    private func presentActionVC(mode: RequestActionMode, request: LocalRequest) {
        let vc = RequestActionViewController(mode: mode, request: request)
        vc.onComplete = { [weak self] in
            self?.showBorrowRequests()
        }
        present(vc, animated: true)
    }

    private func showLendRequests() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        let requests = LocalDataManager.shared.fetchRequests(forEmail: currentUserEmail, isLender: true)
        
        if requests.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No lend requests found."
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = .center
            emptyLabel.font = .systemFont(ofSize: 16)
            stackView.addArrangedSubview(emptyLabel)
            return
        }

        for request in requests {
            let card = RequestCardView(request: request, isLender: true)
            card.onAccept = { [weak self] in
                self?.handleAccept(request: request)
            }
            card.onCancel = { [weak self] in
                self?.handleDecline(request: request)
            }
            card.onChat = { [weak self] in
                self?.handleChat(request: request)
            }
            card.onConfirmReturn = { [weak self] in
                self?.handleConfirmReturn(request: request)
            }
            card.onViewReturnDetails = { [weak self] in
                self?.handleViewReturnDetails(request: request)
            }
            card.onRateUser = { [weak self] in
                self?.presentReviewInput(request: request, isLender: true)
            }
            stackView.addArrangedSubview(card)
        }
    }

    private func handleConfirmReturn(request: LocalRequest) {
        let alert = UIAlertController(title: "Confirm Return", message: "Are you sure you want to confirm that this product has been returned to you?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] _ in
            LocalDataManager.shared.updateRequestStatus(request: request, status: "completed")
            self?.showLendRequests()
            NotificationCenter.default.post(name: NSNotification.Name("RequestsUpdated"), object: nil)
            
            // Prompt Lender to rate Borrower
            self?.presentReviewInput(request: request, isLender: true)
        }))
        present(alert, animated: true)
    }
    
    private func presentReviewInput(request: LocalRequest, isLender: Bool) {
        let otherUserEmail = isLender ? request.borrowerEmail : request.lenderEmail
        let otherUser = LocalDataManager.shared.fetchUser(email: otherUserEmail)
        let otherUserName = otherUser != nil ? "\(otherUser!.firstName) \(otherUser!.lastName)" : "Neighbor"
        
        let vc = ReviewInputViewController(revieweeEmail: otherUserEmail, revieweeName: otherUserName)
        vc.onReviewSubmit = { [weak self] in
            // Refresh to update UI if needed (though card already handles "completed" state UI)
            if isLender { self?.showLendRequests() } else { self?.showBorrowRequests() }
        }
        present(vc, animated: true)
    }

    private func handleViewReturnDetails(request: LocalRequest) {
        let vc = ReturnDetailsViewController(request: request)
        present(vc, animated: true)
    }

    private func handleAccept(request: LocalRequest) {
        let alert = UIAlertController(title: "Accept Request", message: "Are you sure you want to accept this borrow request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] _ in
            LocalDataManager.shared.updateRequestStatus(request: request, status: "accepted")
            self?.showLendRequests()
            NotificationCenter.default.post(name: NSNotification.Name("RequestsUpdated"), object: nil)
        }))
        present(alert, animated: true)
    }

    private func handleDecline(request: LocalRequest) {
        let alert = UIAlertController(title: "Decline Request", message: "Are you sure you want to decline this borrow request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Decline", style: .destructive, handler: { [weak self] _ in
            LocalDataManager.shared.updateRequestStatus(request: request, status: "declined")
            self?.showLendRequests()
            NotificationCenter.default.post(name: NSNotification.Name("RequestsUpdated"), object: nil)
        }))
        present(alert, animated: true)
    }

    private func handleCancel(request: LocalRequest) {
        let alert = UIAlertController(title: "Cancel Request", message: "Are you sure you want to cancel your borrow request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel))
        alert.addAction(UIAlertAction(title: "Cancel Request", style: .destructive, handler: { [weak self] _ in
            LocalDataManager.shared.updateRequestStatus(request: request, status: "cancelled")
            self?.showBorrowRequests()
            NotificationCenter.default.post(name: NSNotification.Name("RequestsUpdated"), object: nil)
        }))
        present(alert, animated: true)
    }

    private func handleChat(request: LocalRequest) {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? UserDefaults.standard.string(forKey: "userEmail") else { return }
        
        // For lenders, the other person is the borrower.
        let otherParticipant = (currentUserEmail == request.lenderEmail) ? request.borrowerEmail : request.lenderEmail
        
        let chat: LocalChat
        if let existingChat = LocalDataManager.shared.fetchChat(productId: request.productId, participant1: currentUserEmail, participant2: otherParticipant) {
            chat = existingChat
        } else {
            chat = LocalDataManager.shared.createChat(productId: request.productId, participant1: currentUserEmail, participant2: otherParticipant)
        }
        
        let detailVC = ChatDetailViewController()
        detailVC.chatId = chat.id
        detailVC.otherParticipantEmail = otherParticipant
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
