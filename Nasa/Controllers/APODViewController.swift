import UIKit

class APODViewController: UIViewController {
    let apodView: APODView = APODView()
    let apodViewModel: APODViewModel
    
    init(with apodViewModel: APODViewModel){
        self.apodViewModel = apodViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.apodViewModel = APODViewModel(with: Constants.apodNetworkingManager)
        
        super.init(coder: coder)
    }
    
    override func loadView() {
        self.view = apodView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.APODViewTitle
        
        setupButtonsActions()
        
        getDataFromAPI()
    }
    
    func getDataFromAPI(with: String? = nil){
        apodViewModel.getDataFromAPI(with: with){ [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result{
            case true:
                guard let model = self.apodViewModel.model else {
                    return
                }

                self.apodView.setupUI(with: model)
            case false:
                guard let error = self.apodViewModel.error else {
                    return
                }
                
                print(error)
            }
        }
    }
    
    func setupButtonsActions() {
        apodView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func searchButtonTapped(_ sender: UIButton) {
        getDataFromAPI(with: Constants.dateFormatter.string(from: apodView.datePicker.date))
    }
}
