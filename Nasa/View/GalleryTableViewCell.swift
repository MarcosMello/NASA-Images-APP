import UIKit

class GalleryTableViewCell: UITableViewCell {
    static let identifier: String = "ReusableCustomImageCell"
    
    let marsRoverImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label: UILabel = UILabel()

        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    func setupUI() {
        let stackView: UIStackView = UIStackView()
        
        self.contentView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(marsRoverImageView)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
