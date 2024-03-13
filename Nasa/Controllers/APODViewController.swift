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
        apodViewModel.getDataFromAPI(with: with) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result{
            case .success(_):
                guard let model = self.apodViewModel.model else {
                    print("Could not unwrap model")
                    return
                }
                
                DispatchQueue.main.async {
                    self.apodView.setupUI(with: model)
                }
            case .failure(let error):
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
