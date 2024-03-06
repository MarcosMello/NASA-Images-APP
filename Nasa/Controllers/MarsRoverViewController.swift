import UIKit

class MarsRoverViewController: UIViewController {
    let marsRoverView: MarsRoverView = MarsRoverView()
    let marsRoverViewModel: MarsRoverViewModel
    
    init(with marsRoverViewModel: MarsRoverViewModel) {
        self.marsRoverViewModel = marsRoverViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.marsRoverViewModel = MarsRoverViewModel(with: Constants.marsRoverNetworkingManager)
        
        super.init(coder: coder)
    }
    
    override func loadView() {
        self.view = marsRoverView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.marsRoverViewTitle
        
        marsRoverView.tableView.delegate = self
        marsRoverView.tableView.dataSource = self
        
        marsRoverView.cameraPickerView.delegate = self
        marsRoverView.cameraPickerView.dataSource = self
        
        marsRoverView.selectCameraTextField.inputView = marsRoverView.cameraPickerView
        
        marsRoverView.tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: GalleryTableViewCell.identifier)
        
        marsRoverViewModel.onPageChange = { pageIndicatorText in
            self.marsRoverView.pageIndicatorLabel.text = pageIndicatorText
        }
        marsRoverViewModel.onDatePickerMinimumDateChange = { minimumDate in
            self.marsRoverView.datePicker.minimumDate = minimumDate
        }
        marsRoverViewModel.onDatePickerMaximumDateChange = { maximumDate in
            self.marsRoverView.datePicker.maximumDate = maximumDate
        }
        marsRoverViewModel.onTableViewNeedsReload = {
            self.marsRoverView.tableView.reloadData()
        }
        
        setupButtonsActions()
    }
    
    func setupButtonsActions() {
        self.marsRoverView.subtractPageButton.addTarget(self, action: #selector(PreviousPageButtonTapped), for: .touchUpInside)
        self.marsRoverView.addPageButton.addTarget(self, action: #selector(NextPageButtonTapped), for: .touchUpInside)
        self.marsRoverView.searchButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func NextPageButtonTapped(_ sender: UIButton) {
        marsRoverViewModel.updatePageIndicator(with: 1)
    }
    
    @objc
    func PreviousPageButtonTapped(_ sender: UIButton) {
        marsRoverViewModel.updatePageIndicator(with: -1)
    }
    
    @objc
    func filterButtonTapped(_ sender: UIButton) {
        let earth_date = Constants.dateFormatter.string(from: marsRoverView.datePicker.date)
        
        var queryParameters = ["earth_date=\(earth_date)", "page=\(marsRoverViewModel.page)"]
        
        if let selectedCamera = marsRoverView.selectCameraTextField.text {
            if (selectedCamera != Constants.allCamerasOption) {
                queryParameters.append("camera=\(selectedCamera)")
            }
        }
        
        marsRoverViewModel.callGetEndpoint(networkingManager: marsRoverViewModel.networkingManager, endpoint: "mars-photos/api/v1/rovers/curiosity/photos", queryParameters: queryParameters)
    } // TODO: Apenas reformular para chamar a API no ViewModel?
}

extension MarsRoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.componentsOfGaleryViewUIPicker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marsRoverViewModel.marsRoversCameras?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return marsRoverViewModel.marsRoversCameras?[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        marsRoverView.selectCameraTextField.text = marsRoverViewModel.marsRoversCameras?[row].name ?? ""
        
        marsRoverView.selectCameraTextField.resignFirstResponder()
    }
} // TODO: Passar inteiro para o ViewModel?

extension MarsRoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marsRoverViewModel.marsRoverImages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.identifier, for: indexPath) as! GalleryTableViewCell
        
        if let urlString = (marsRoverViewModel.marsRoverImages?[indexPath.row])?.img_src, let url = URL(string: urlString){
            
            if var comps = URLComponents(url: url, resolvingAgainstBaseURL: false){
                comps.scheme = "https"
                
                if let safeURL = comps.url{
                    cell.marsRoverImageView.load(url: safeURL)
                }
            }
        }
        
        cell.descriptionLabel.text = "\((marsRoverViewModel.marsRoverImages?[indexPath.row])?.camera.name ?? "") @ \((marsRoverViewModel.marsRoverImages?[indexPath.row])?.earth_date ?? "")"
        
        return cell
    }
} // TODO: Passar inteiro para o ViewModel?

extension MarsRoverViewController: UITableViewDelegate {
    func showDetailsModal(with detailsViewModel: DetailsViewModel){
        let detailsViewController: DetailsViewController = DetailsViewController(with: detailsViewModel)
        
        present(detailsViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = (tableView.cellForRow(at: indexPath) as? GalleryTableViewCell)
        
        showDetailsModal(with: DetailsViewModel(with: cell))
    }
}
