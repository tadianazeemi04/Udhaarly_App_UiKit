import UIKit

class ReturnDetailsViewController: UIViewController {
    
    private let request: LocalRequest
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Return Details"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    private let conditionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Borrower's Note on Condition:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Close", for: .normal)
        btn.backgroundColor = .brandOrange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 12
        return btn
    } ()
    
    init(request: LocalRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configure()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, imageView, conditionTitleLabel, conditionLabel, dateLabel, closeButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            conditionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            conditionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            conditionLabel.topAnchor.constraint(equalTo: conditionTitleLabel.bottomAnchor, constant: 8),
            conditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            conditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            closeButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 40),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    private func configure() {
        if let imageData = request.returnImage {
            imageView.image = UIImage(data: imageData)
        }
        conditionLabel.text = request.returnCondition ?? "No condition notes provided."
        
        if let date = request.returnDate {
            let df = DateFormatter()
            df.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
            dateLabel.text = "Date Returned: \(df.string(from: date))"
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
