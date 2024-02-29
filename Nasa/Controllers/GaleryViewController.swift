import UIKit

class GaleryViewController: UIViewController {
    var actualPage: Int = 1
    var intentionalPage: Int = 0
    
    var selectedImageTitle: String?
    var selectedImage: UIImage?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cameraTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pageIndicator: UILabel!
    
    let cameraPickerView = UIPickerView()
    
    var marsRoverNetworkingManager = NetworkingManager<MarsRoverModel>(baseURL: "https://api.nasa.gov/")
    
    var marsRoverModel: MarsRoverModel?
    var marsRoverImages: [MarsRoverImagesModel]?
    
    
    static let marsRoverAllCamera: MarsRoverCameraModel = MarsRoverCameraModel(name: Constants.allCameraOption, full_name: Constants.allCameraOption)
    var marsRoversCameras: [MarsRoverCameraModel]? = [marsRoverAllCamera]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cameraPickerView.delegate = self
        cameraPickerView.dataSource = self
        
        cameraTextField.inputView = cameraPickerView
        
        tableView.register(UINib(nibName: Constants.galeryViewCustomTableCell, bundle: nil), forCellReuseIdentifier: Constants.galeryViewCustomTableCellIdentifier)
        
        marsRoverNetworkingManager.delegate = self
        
        callGetEndpoint(networkingManager: marsRoverNetworkingManager, endpoint: "mars-photos/api/v1/rovers/curiosity/photos", queryParameters: ["sol=0", "page=1", "api_key=DEMO_KEY"])
    }
    
    func updatePageIndicator(with page: Int){
        pageIndicator.text = "Página \(page)"
        
        intentionalPage = page
    }
    
    @IBAction func NextPageButtonTapped(_ sender: UIButton) {
        updatePageIndicator(with: intentionalPage + 1)
    }
    
    @IBAction func PreviousPageButtonTapped(_ sender: UIButton) {
        updatePageIndicator(with: intentionalPage > 1 ? intentionalPage - 1 : intentionalPage)
    }
    
    func callGetEndpoint<T>(networkingManager: NetworkingManager<T>, endpoint: String, queryParameters: [String]? = nil){
        guard let apiKey = ProcessInfo.processInfo.environment["NASA_API_KEY"] else {
            print("Add the NASA API key on the env")
            return
        }
        
        let url = networkingManager.prepareURL(endpoint: endpoint, apiKey: apiKey, queryParameters: queryParameters)
        
        guard let unwrappedURL = url else {
            return
        }
        
        networkingManager.getTask(with: unwrappedURL)
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let earth_date = dateFormatter.string(from: datePicker.date)
        
        actualPage = intentionalPage
        
        var queryParameters = ["earth_date=\(earth_date)", "page=\(actualPage)"]
        
        if let selectedCamera = cameraTextField.text {
            if (selectedCamera != Constants.allCameraOption) {
                queryParameters.append("camera=\(selectedCamera)")
            }
        }
        
        callGetEndpoint(networkingManager: marsRoverNetworkingManager, endpoint: "mars-photos/api/v1/rovers/curiosity/photos", queryParameters: queryParameters)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueFromGaleryToDetails{
            guard let detailsView = segue.destination as? DetailsViewController else {
                return
            }
            
            detailsView.imageTitle = selectedImageTitle
            detailsView.image = selectedImage
        }
    }
}

extension GaleryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        cameraTextField.text = marsRoversCameras?[row].name ?? ""
        
        cameraTextField.resignFirstResponder()
    }
}

extension GaleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marsRoverImages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.galeryViewCustomTableCellIdentifier, for: indexPath) as! GaleryTableViewCell
        
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

extension GaleryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = (tableView.cellForRow(at: indexPath) as? GaleryTableViewCell)
        
        selectedImageTitle = cell?.descriptionLabel.text
        selectedImage = cell?.marsRoverImageView.image
        
        performSegue(withIdentifier: Constants.segueFromGaleryToDetails, sender: self)
    }
}

extension GaleryViewController: NetworkingManagerDelegate {
    func onSuccess<T>(_ networkingMaganer: NetworkingManager<T>, with decodableModel: Decodable) where T : Decodable {
        DispatchQueue.main.async {
            if let marsRoverModelInstance = decodableModel as? MarsRoverModel{
                self.marsRoverModel = marsRoverModelInstance
                self.marsRoverImages = self.marsRoverModel?.photos
                
                if !marsRoverModelInstance.photos.isEmpty {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    let minimumDate = dateFormatter.date(from: marsRoverModelInstance.photos[0].rover.landing_date)
                    let maximumDate = dateFormatter.date(from: marsRoverModelInstance.photos[0].rover.max_date)
                    
                    if let unwrappedMinimumDate = minimumDate, let unwrappedMaximumDate = maximumDate {
                        self.datePicker.minimumDate = unwrappedMinimumDate
                        self.datePicker.maximumDate = unwrappedMaximumDate
                    }
                    
                    self.marsRoversCameras = [GaleryViewController.marsRoverAllCamera]
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
