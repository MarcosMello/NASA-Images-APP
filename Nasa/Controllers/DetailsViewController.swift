import UIKit

class DetailsViewController: UIViewController {
    let detailsView: DetailsView = DetailsView()
    let detailsViewModel: DetailsViewModel
    
    init(with detailsViewModel: DetailsViewModel) {
        self.detailsViewModel = detailsViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        self.view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsView.titleLabel.text = detailsViewModel.imageTitle
        detailsView.imageView.image = detailsViewModel.image
    }
}
