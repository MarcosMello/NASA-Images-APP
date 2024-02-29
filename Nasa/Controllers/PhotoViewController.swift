import UIKit

class PhotoViewController: UIViewController, NetworkingManagerDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explanationTextView: UITextView!
    
    var networkingManager = NetworkingManager<APODModel>(baseURL: "https://api.nasa.gov/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()
        
        networkingManager.delegate = self
        
        callAPODEndpoint()
    }
    
    func callAPODEndpoint(with date: String? = nil){
        guard let apiKey = ProcessInfo.processInfo.environment["NASA_API_KEY"] else {
            print("Add the NASA API key on the env")
            return
        }
        
        var url: String? = networkingManager.prepareURL(endpoint: "planetary/apod", apiKey: apiKey)
        
        if let date = date {
            url = networkingManager.prepareURL(endpoint: "planetary/apod", apiKey: apiKey, queryParameters: ["date=\(date)"])
        }
          
        if let unwrappedURL = url{
            networkingManager.getTask(with: unwrappedURL)
        }
    }
    
    @IBAction func showImageButtonTapped(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "yyyy-MM-dd"

        callAPODEndpoint(with: dateFormatter.string(from: datePicker.date))
    }
    
    func onSuccess<T>(_ networkingMaganer: NetworkingManager<T>, with decodableModel: Decodable) where T : Decodable {
        DispatchQueue.main.async {
            let APODModelInstance = decodableModel as? APODModel
            
            guard let unwrappedAPODModelInstance = APODModelInstance else {
                return
            }
            
            self.imageTitleLabel.text = unwrappedAPODModelInstance.title
            self.explanationTextView.text = unwrappedAPODModelInstance.explanation
            
            let url = URL(string: unwrappedAPODModelInstance.hdurl ?? unwrappedAPODModelInstance.url)
            
            if let unwrappedURL = url{
                self.imageView.load(url: unwrappedURL)
            }
        }
    }
    
    func onFail(with error: Error) {
        print(error)
    }
}
