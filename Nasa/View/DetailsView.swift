import UIKit

class DetailsView: UIView {
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = Constants.defaultTitleText
        label.textAlignment = .center
        
        return label
    }()
    
    let imageView: UIImageView = {
        UIImageView(image: Constants.nasaLogo)
    }()
    
    func startUI(){
        self.backgroundColor = .systemBackground
        
        let stackView: UIStackView = UIStackView()
        
        self.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        startUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        startUI()
    }
}
