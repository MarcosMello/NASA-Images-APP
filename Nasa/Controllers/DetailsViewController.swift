import UIKit

class DetailsViewController: UIViewController {
    var imageTitle: String?
    var image: UIImage?
    
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
        self.view.backgroundColor = .systemBackground
        
        let stackView: UIStackView = UIStackView()
        
        self.view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = imageTitle
        imageView.image = image
        
        startUI()
    }
}
