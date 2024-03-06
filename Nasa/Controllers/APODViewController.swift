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
        
        apodViewModel.callAPODEndpoint()
        
        self.apodViewModel.onImageTitleChange = { [weak self] imageTitle in
            DispatchQueue.main.async {
                self?.apodView.imageTitleLabel.text = imageTitle
            }
        }
        self.apodViewModel.onExplanationChange = { [weak self] explanation in
            DispatchQueue.main.async {
                self?.apodView.explanationTextView.text = explanation
            }
        }
        self.apodViewModel.onImageURLChange = { [weak self] imageURL in
            DispatchQueue.main.async {
                self?.apodView.imageView.load(url: imageURL)
            }
        }
    }
    
    func setupButtonsActions() {
        apodView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func searchButtonTapped(_ sender: UIButton) {
        apodViewModel.callAPODEndpoint(with: Constants.dateFormatter.string(from: apodView.datePicker.date))
    }
}
