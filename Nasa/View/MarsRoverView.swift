import UIKit

class MarsRoverView: UIView {
    let datePickerLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = Constants.marsRoverDatePickerLabelText
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    let selectCameraLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = Constants.marsRoverSelectCameraLabelText
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    let cameraPickerView: UIPickerView = UIPickerView()
    
    let selectCameraTextField: UITextField = {
        let textField: UITextField = UITextField()
        
        textField.text = Constants.allCamerasOption
        textField.textAlignment = .right
        
        return textField
    }()
    
    let subtractPageButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("-", for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        return button
    }()
    
    let pageIndicatorLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = Constants.marsRoverPageDefaultText
        label.textAlignment = .center
        
        return label
    }()

    let addPageButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("+", for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.marsRoverSearchButtonTitle, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        return button
    }()
    
    let tableView: UITableView = {
        UITableView()
    }()
    
    func startUI(){
        self.backgroundColor = .systemBackground
        
        let pagesStackView: UIStackView = {
            let stackView: UIStackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            stackView.spacing = 0
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(subtractPageButton)
            stackView.addArrangedSubview(pageIndicatorLabel)
            stackView.addArrangedSubview(addPageButton)
            
            return stackView
        }()
        
        let cameraSelectorStackView: UIStackView = {
            let stackView: UIStackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            stackView.spacing = 0
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(selectCameraLabel)
            stackView.addArrangedSubview(selectCameraTextField)
            
            return stackView
        }()
        
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
        
        let filterStackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            stackView.spacing = 20
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(labelAndDatePickerStackView)
            stackView.addArrangedSubview(cameraSelectorStackView)
            stackView.addArrangedSubview(pagesStackView)
            stackView.addArrangedSubview(searchButton)
            
            return stackView
        }()
        
        let mainStackView: UIStackView = UIStackView()
        
        self.addSubview(mainStackView)
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        
        mainStackView.spacing = 0
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        mainStackView.addArrangedSubview(filterStackView)
        mainStackView.addArrangedSubview(tableView)
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
