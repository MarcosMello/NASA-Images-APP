import Foundation

class APODViewModel{
    let endpoint: String = "planetary/apod"
    
    var model: APODModel?
    var error: NetworkingManagerError?
    
    var networkingManager: NetworkingManager<APODModel>
    
    init(with networkingManager: NetworkingManager<APODModel>){
        self.networkingManager = networkingManager
    }
    
    func getDataFromAPI(with date: String? = nil, completion: @escaping (Bool) -> Void) {
        var queryParameters: [String]? = nil
        
        if let date = date {
            queryParameters = ["date=\(date)"]
        }
        
        networkingManager.getTask(endpoint: self.endpoint, queryParameters: queryParameters) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result{
            case .success(let model):
                self.model = model
                
                completion(true)
            case .failure(let error):
                self.error = error
                
                completion(false)
            }
        }
    }
}
