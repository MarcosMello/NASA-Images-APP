import UIKit

class APODView: UIView {
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
        self.backgroundColor = .systemBackground
        
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
            
            self.addSubview(stackView)
            
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            stackView.spacing = 5
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            stackView.addArrangedSubview(titleAndDateStackView)
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(explanationTextView)
            
            return stackView
        }()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        startUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        startUI()
    }
    
    func setupUI(with model: APODModel){
        DispatchQueue.main.async {
            self.imageTitleLabel.text = model.title
            self.explanationTextView.text = model.explanation
            
            self.imageView.image = Constants.nasaLogo
            
            self.imageView.load(url: URL(string: model.hdurl ?? model.url))
        }
    }
}
