import UIKit

class MarsRoverViewController: UIViewController {
    var apiKey: String = "DEMO_KEY"
    
    var actualPage: Int = 1
    var intentionalPage: Int = 0
    
    var selectedImageTitle: String?
    var selectedImage: UIImage?
    
    var marsRoverNetworkingManager = NetworkingManager<MarsRoverModel>(baseURL: "https://api.nasa.gov/")
    
    var marsRoverModel: MarsRoverModel?
    var marsRoverImages: [MarsRoverImagesModel]?
    
    static let marsRoverAllCamera: MarsRoverCameraModel = MarsRoverCameraModel(name: Constants.allCameraOption, full_name: Constants.allCameraOption)
    var marsRoversCameras: [MarsRoverCameraModel]? = [marsRoverAllCamera]
    
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
    
    func setupButtonsActions() {
        subtractPageButton.addTarget(self, action: #selector(PreviousPageButtonTapped), for: .touchUpInside)
        addPageButton.addTarget(self, action: #selector(NextPageButtonTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    func startUI(){
        self.title = Constants.marsRoverViewTitle
        self.view.backgroundColor = .systemBackground
        
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
        
        self.view.addSubview(mainStackView)
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        
        mainStackView.spacing = 0
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        mainStackView.addArrangedSubview(filterStackView)
        mainStackView.addArrangedSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cameraPickerView.delegate = self
        cameraPickerView.dataSource = self
        
        selectCameraTextField.inputView = cameraPickerView
        
        marsRoverNetworkingManager.delegate = self
        
        tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: GalleryTableViewCell.identifier)
        
        setupButtonsActions()
        startUI()
        
        apiKey = ProcessInfo.processInfo.environment["NASA_API_KEY"] ?? "DEMO_KEY"
        
        callGetEndpoint(networkingManager: marsRoverNetworkingManager, endpoint: "mars-photos/api/v1/rovers/curiosity/photos", queryParameters: ["sol=0", "page=1", "api_key=\(apiKey)"])
    }
    
    func updatePageIndicator(with page: Int){
        pageIndicatorLabel.text = "Página \(page)"
        
        intentionalPage = page
    }
    
    @objc
    func NextPageButtonTapped(_ sender: UIButton) {
        updatePageIndicator(with: intentionalPage + 1)
    }
    
    @objc
    func PreviousPageButtonTapped(_ sender: UIButton) {
        updatePageIndicator(with: intentionalPage > 1 ? intentionalPage - 1 : intentionalPage)
    }
    
    func callGetEndpoint<T>(networkingManager: NetworkingManager<T>, endpoint: String, queryParameters: [String]? = nil){
        
        let url = networkingManager.prepareURL(endpoint: endpoint, apiKey: apiKey, queryParameters: queryParameters)
        
        guard let unwrappedURL = url else {
            return
        }
        
        networkingManager.getTask(with: unwrappedURL)
    }
    
    @objc
    func filterButtonTapped(_ sender: UIButton) {
        let earth_date = Constants.dateFormatter.string(from: datePicker.date)
        
        actualPage = intentionalPage
        
        var queryParameters = ["earth_date=\(earth_date)", "page=\(actualPage)"]
        
        if let selectedCamera = selectCameraTextField.text {
            if (selectedCamera != Constants.allCameraOption) {
                queryParameters.append("camera=\(selectedCamera)")
            }
        }
        
        callGetEndpoint(networkingManager: marsRoverNetworkingManager, endpoint: "mars-photos/api/v1/rovers/curiosity/photos", queryParameters: queryParameters)
    }
}

extension MarsRoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.componentsOfGaleryViewUIPicker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marsRoversCameras?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return marsRoversCameras?[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCameraTextField.text = marsRoversCameras?[row].name ?? ""
        
        selectCameraTextField.resignFirstResponder()
    }
}

extension MarsRoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marsRoverImages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.identifier, for: indexPath) as! GalleryTableViewCell
        
        if let urlString = (marsRoverImages?[indexPath.row])?.img_src, let url = URL(string: urlString){
            
            if var comps = URLComponents(url: url, resolvingAgainstBaseURL: false){
                comps.scheme = "https"
                
                if let safeURL = comps.url{
                    cell.marsRoverImageView.load(url: safeURL)
                }
            }
        }
        
        cell.descriptionLabel.text = "\((marsRoverImages?[indexPath.row])?.camera.name ?? "") @ \((marsRoverImages?[indexPath.row])?.earth_date ?? "")"
        
        return cell
    }
}

extension MarsRoverViewController: UITableViewDelegate {
    func showDetailsModal(image: UIImage?, title: String?){
        let detailsViewController: DetailsViewController = DetailsViewController()
        
        detailsViewController.image = image
        detailsViewController.imageTitle = title
        
        present(detailsViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = (tableView.cellForRow(at: indexPath) as? GalleryTableViewCell)
        
        selectedImage = cell?.marsRoverImageView.image
        selectedImageTitle = cell?.descriptionLabel.text
        
        showDetailsModal(image: selectedImage, title: selectedImageTitle)
    }
}

extension MarsRoverViewController: NetworkingManagerDelegate {
    func onSuccess<T>(_ networkingMaganer: NetworkingManager<T>, with decodableModel: Decodable) where T : Decodable {
        DispatchQueue.main.async {
            if let marsRoverModelInstance = decodableModel as? MarsRoverModel{
                self.marsRoverModel = marsRoverModelInstance
                self.marsRoverImages = self.marsRoverModel?.photos
                
                if !marsRoverModelInstance.photos.isEmpty {
                    let minimumDate = Constants.dateFormatter.date(from: marsRoverModelInstance.photos[0].rover.landing_date)
                    let maximumDate = Constants.dateFormatter.date(from: marsRoverModelInstance.photos[0].rover.max_date)
                    
                    if let unwrappedMinimumDate = minimumDate, let unwrappedMaximumDate = maximumDate {
                        self.datePicker.minimumDate = unwrappedMinimumDate
                        self.datePicker.maximumDate = unwrappedMaximumDate
                    }
                    
                    self.marsRoversCameras = [MarsRoverViewController.marsRoverAllCamera]
                    self.marsRoversCameras?.append(contentsOf: marsRoverModelInstance.photos[0].rover.cameras)
                    
                    self.updatePageIndicator(with: self.actualPage)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func onFail(with error: Error) {
        print(error)
    }
}
