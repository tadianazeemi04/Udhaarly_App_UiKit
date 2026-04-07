import UIKit

class MyReviewsViewController: UIViewController {

    // MARK: - Properties
    private var receivedReviews: [LocalReview] = []
    private var placedReviews: [LocalReview] = []
    private var currentSegment = 0 // 0: Received, 1: Placed

    // MARK: - UI Components
    private let headerGradient: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.colors = [UIColor(hex: "#FF6700"), UIColor(hex: "#E90007")]
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
        label.text = "My Reviews"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Received", "Placed"])
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .white
        sc.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        sc.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        tv.register(EmptyStateCell.self, forCellReuseIdentifier: EmptyStateCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(hex: "#FAFAFA")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(headerGradient)
        headerGradient.addSubview(backButton)
        headerGradient.addSubview(navTitleLabel)
        headerGradient.addSubview(segmentedControl)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerGradient.topAnchor.constraint(equalTo: view.topAnchor),
            headerGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerGradient.heightAnchor.constraint(equalToConstant: 200),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: headerGradient.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            navTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navTitleLabel.centerXAnchor.constraint(equalTo: headerGradient.centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: navTitleLabel.bottomAnchor, constant: 30),
            segmentedControl.leadingAnchor.constraint(equalTo: headerGradient.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: headerGradient.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: headerGradient.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    private func fetchData() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
        
        receivedReviews = LocalDataManager.shared.fetchReviews(forEmail: currentUserEmail)
        placedReviews = LocalDataManager.shared.fetchReviewsBy(email: currentUserEmail)
        
        tableView.reloadData()
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func segmentChanged() {
        currentSegment = segmentedControl.selectedSegmentIndex
        tableView.reloadData()
    }
}

extension MyReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = currentSegment == 0 ? receivedReviews.count : placedReviews.count
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviews = currentSegment == 0 ? receivedReviews : placedReviews
        
        if reviews.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateCell.identifier, for: indexPath) as! EmptyStateCell
            let message = currentSegment == 0 ? "You haven't received any reviews yet." : "You haven't placed any reviews yet."
            cell.configure(with: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
            cell.configure(with: reviews[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let reviews = currentSegment == 0 ? receivedReviews : placedReviews
        return reviews.isEmpty ? 200 : UITableView.automaticDimension
    }
}
