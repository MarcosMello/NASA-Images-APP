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
        
        setupButtonsActions()
        
        getDataFromAPI(sol: 0)
    }
    
    func setupButtonsActions() {
        self.marsRoverView.subtractPageButton.addTarget(self, action: #selector(PreviousPageButtonTapped), for: .touchUpInside)
        self.marsRoverView.addPageButton.addTarget(self, action: #selector(NextPageButtonTapped), for: .touchUpInside)
        self.marsRoverView.searchButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func NextPageButtonTapped(_ sender: UIButton) {
        marsRoverViewModel.updatePageIndicator(with: 1)
        
        marsRoverView.setupUI(pageIndicatorText: marsRoverViewModel.pageIndicator)
    }
    
    @objc
    func PreviousPageButtonTapped(_ sender: UIButton) {
        marsRoverViewModel.updatePageIndicator(with: -1)
        
        marsRoverView.setupUI(pageIndicatorText: marsRoverViewModel.pageIndicator)
    }
    
    @objc
    func filterButtonTapped(_ sender: UIButton) {
        getDataFromAPI(
            earthDate: marsRoverView.datePicker.date,
            camera: marsRoverView.selectCameraTextField.text
        )
    }
    
    func getDataFromAPI(earthDate: Date? = nil, camera: String? = nil, sol: Int? = nil, page: Int = Constants.initialPageNumber){
        marsRoverViewModel.getDataFromAPI(
            earthDate: earthDate,
            camera: camera,
            sol: sol,
            page: page
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case true:
                self.marsRoverView.setupUI(
                    pageIndicatorText: self.marsRoverViewModel.pageIndicator,
                    minimumDate: self.marsRoverViewModel.minimumDate,
                    maximumDate: self.marsRoverViewModel.maximumDate,
                    shouldReloadTable: true
                )
            case false:
                guard let error = self.marsRoverViewModel.error else {
                    return
                }
                
                print(error)
            }
        }
    }
}

extension MarsRoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.componentsOfGaleryViewUIPicker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marsRoverViewModel.marsRoversCamerasLength
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return marsRoverViewModel.marsRoversCameras?[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        marsRoverView.selectCameraTextField.text = marsRoverViewModel.marsRoversCameras?[row].name ?? ""
        
        marsRoverView.selectCameraTextField.resignFirstResponder()
    }
}

extension MarsRoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marsRoverViewModel.marsRoverImagesLength
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.identifier, for: indexPath) as! GalleryTableViewCell
        
        let galleryTableViewCellViewModel: GalleryTableViewCellViewModel = GalleryTableViewCellViewModel(
            with: marsRoverViewModel.marsRoverImages?[indexPath.row]
        )
        
        cell.setupUI(
            imgUrl: galleryTableViewCellViewModel.imgUrl,
            descriptionLabelText: galleryTableViewCellViewModel.descriptionLabelText
        )
        
        return cell
    }
}

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
