import UIKit

class EmptyStateCell: UITableViewCell {
    static let identifier = "EmptyStateCell"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: String) {
        messageLabel.text = message
    }
}
