import Foundation

class APODViewModel{
    var onImageTitleChange: ((String) -> (Void))?
    var onExplanationChange: ((String) -> (Void))?
    var onImageURLChange: ((URL) -> (Void))?
    
    var networkingManager: NetworkingManager<APODModel>
    
    init(with networkingManager: NetworkingManager<APODModel>){
        self.networkingManager = networkingManager
        
        self.networkingManager.delegate = self
    }
    
    func callAPODEndpoint(with date: String? = nil){
        var url: String? = networkingManager.prepareURL(endpoint: "planetary/apod", apiKey: Constants.nasaApiKey)
        
        if let date = date {
            url = networkingManager.prepareURL(endpoint: "planetary/apod", apiKey: Constants.nasaApiKey, queryParameters: ["date=\(date)"])
        }
          
        if let unwrappedURL = url{
            networkingManager.getTask(with: unwrappedURL)
        }
    }
}

extension APODViewModel: NetworkingManagerDelegate {
    func onSuccess<T>(_ networkingMaganer: NetworkingManager<T>, with decodableModel: Decodable) where T : Decodable {
        DispatchQueue.main.async {
            let APODModelInstance = decodableModel as? APODModel
            
            guard let unwrappedAPODModelInstance = APODModelInstance else {
                return
            }
            
            self.onImageTitleChange?(unwrappedAPODModelInstance.title)
            self.onExplanationChange?(unwrappedAPODModelInstance.explanation)
            
            let url = URL(string: unwrappedAPODModelInstance.hdurl ?? unwrappedAPODModelInstance.url)
            
            if let unwrappedURL = url{
                self.onImageURLChange?(unwrappedURL)
            }
        }
    }
    
    func onFail(with error: Error) {
        print(error)
    }
}
