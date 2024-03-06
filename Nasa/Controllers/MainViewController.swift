import UIKit

class MainViewController: UIViewController {

    let logoNASAImageView: UIImageView = {
        UIImageView(image: Constants.nasaLogo)
    }()
    
    let APODButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.MainViewControllerAPODButtonTitle, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        return button
    }()
    
    let marsRoverButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.MainViewControllerMarsRoverButtonTitle, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        return button
    }()
    
    func setupButtonsActions() {
        APODButton.addTarget(self, action: #selector(APODButtonTapped), for: .touchUpInside)
        marsRoverButton.addTarget(self, action: #selector(MarsRoverButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        let mainContainer = UIStackView()
        let buttonContainer = UIStackView()
        
        self.view.addSubview(mainContainer)
        mainContainer.addArrangedSubview(logoNASAImageView)
        mainContainer.addArrangedSubview(buttonContainer)
        
        buttonContainer.addArrangedSubview(APODButton)
        buttonContainer.addArrangedSubview(marsRoverButton)
        
        mainContainer.axis = .vertical
        buttonContainer.axis = .vertical
        
        mainContainer.distribution = .fillEqually
        buttonContainer.distribution = .fillEqually
        
        mainContainer.spacing = 25
        buttonContainer.spacing = 40
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        mainContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mainContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        mainContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsActions()
        setupUI()
    }
    
    @objc
    func APODButtonTapped() {
        navigationController?.pushViewController(
            APODViewController(with: APODViewModel(with: Constants.apodNetworkingManager)),
            animated: true
        )
    }
    
    @objc
    func MarsRoverButtonTapped() {
        navigationController?.pushViewController(MarsRoverViewController(with: MarsRoverViewModel(with: Constants.marsRoverNetworkingManager)), animated: true)
    }
}

