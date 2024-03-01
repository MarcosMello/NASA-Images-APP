import UIKit

class APODViewController: UIViewController {
    var networkingManager = NetworkingManager<APODModel>(baseURL: "https://api.nasa.gov/")
    
    let datePickerLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = Constants.APODDatePickerLabelText
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Constants.dateFormatter.date(from: Constants.APODMinimumDate)
        datePicker.maximumDate = Date()
        
        return datePicker
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.APODSearchButtonTitle, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        return button
    }()
    
    let imageTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = Constants.defaultTitleText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let imageView: UIImageView = {
        UIImageView(image: Constants.nasaLogo)
    }()
    
    let explanationTextView: UITextView = {
        let textView: UITextView = UITextView()
        
        textView.text = Constants.APODImageDescriptionDefaultText
        textView.textAlignment = .center
        textView.isEditable = false
        textView.font = UIFont(name: Constants.defaultFontName, size: 14.0)
        
        return textView
    }()
    
    func startUI() {
        self.title = Constants.APODViewTitle
        self.view.backgroundColor = .systemBackground
        
        let labelAndDatePickerStackView: UIStackView = {
            let stackView: UIStackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            stackView.spacing = 0
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(datePickerLabel)
            stackView.addArrangedSubview(datePicker)
            
            return stackView
        }()
        
        let dateStackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            stackView.spacing = 5
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(labelAndDatePickerStackView)
            stackView.addArrangedSubview(searchButton)
            
            return stackView
        }()
        
        let titleAndDateStackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            stackView.spacing = 5
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(dateStackView)
            stackView.addArrangedSubview(imageTitleLabel)
            
            return stackView
        }()
        
        let _: UIStackView = {
            let stackView: UIStackView = UIStackView()
            
            self.view.addSubview(stackView)
            
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            stackView.spacing = 5
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            stackView.addArrangedSubview(titleAndDateStackView)
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(explanationTextView)
            
            return stackView
        }()
    }
    
    func setupButtonsActions() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkingManager.delegate = self
        
        setupButtonsActions()
        startUI()
        
        callAPODEndpoint()
    }
    
    func callAPODEndpoint(with date: String? = nil){
        guard let apiKey = ProcessInfo.processInfo.environment["NASA_API_KEY"] else {
            print("Add the NASA API key on the env")
            return
        }
        
        var url: String? = networkingManager.prepareURL(endpoint: "planetary/apod", apiKey: apiKey)
        
        if let date = date {
            url = networkingManager.prepareURL(endpoint: "planetary/apod", apiKey: apiKey, queryParameters: ["date=\(date)"])
        }
          
        if let unwrappedURL = url{
            networkingManager.getTask(with: unwrappedURL)
        }
    }
    
    @objc
    func searchButtonTapped(_ sender: UIButton) {
        callAPODEndpoint(with: Constants.dateFormatter.string(from: datePicker.date))
    }
}

extension APODViewController: NetworkingManagerDelegate {
    func onSuccess<T>(_ networkingMaganer: NetworkingManager<T>, with decodableModel: Decodable) where T : Decodable {
        DispatchQueue.main.async {
            let APODModelInstance = decodableModel as? APODModel
            
            guard let unwrappedAPODModelInstance = APODModelInstance else {
                return
            }
            
            self.imageTitleLabel.text = unwrappedAPODModelInstance.title
            self.explanationTextView.text = unwrappedAPODModelInstance.explanation
            
            let url = URL(string: unwrappedAPODModelInstance.hdurl ?? unwrappedAPODModelInstance.url)
            
            if let unwrappedURL = url{
                self.imageView.load(url: unwrappedURL)
            }
        }
    }
    
    func onFail(with error: Error) {
        print(error)
    }
}
