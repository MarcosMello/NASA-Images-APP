import UIKit

class MarsRoverViewModel {
    var networkingManager: NetworkingManager<MarsRoverModel>
    
    var onPageChange: ((String) -> (Void))?
    var onDatePickerMinimumDateChange: ((Date) -> (Void))?
    var onDatePickerMaximumDateChange: ((Date) -> (Void))?
    var onTableViewNeedsReload: (() -> (Void))?
    
    var marsRoverModel: MarsRoverModel?
    var marsRoverImages: [MarsRoverImagesModel]? {
        return self.marsRoverModel?.photos
    }
    
    var page: Int = 0
    
    var marsRoversCameraOptions : [MarsRoverCameraModel]?
    var marsRoversCameras: [MarsRoverCameraModel]? {
        return [Constants.marsRoverAllCamerasOption] + (marsRoversCameraOptions ?? [])
    }
    
    var pageIndicator: String {
        return "Página \(self.page)"
    }
    
    init(with networkingManager: NetworkingManager<MarsRoverModel>){
        self.networkingManager = networkingManager
        
        self.networkingManager.delegate = self
        
        callGetEndpoint(
            networkingManager: self.networkingManager,
            endpoint: "mars-photos/api/v1/rovers/curiosity/photos",
            queryParameters: ["sol=0", "page=1", "api_key=\(Constants.nasaApiKey)"]
        )
    }
    
    func updatePageIndicator(with updateAmount: Int){
        self.page = self.page + updateAmount > 0 ? self.page + updateAmount : 1
        
        self.onPageChange?(pageIndicator)
    }
}

extension MarsRoverViewModel: NetworkingManagerDelegate {
    func callGetEndpoint<T>(networkingManager: NetworkingManager<T>, endpoint: String, queryParameters: [String]? = nil){
        
        let url = networkingManager.prepareURL(endpoint: endpoint, apiKey: Constants.nasaApiKey, queryParameters: queryParameters)
        
        if let unwrappedURL = url {
            networkingManager.getTask(with: unwrappedURL)
        }
        
        return
    }
    
    func onSuccess<T>(_ networkingMaganer: NetworkingManager<T>, with decodableModel: Decodable) where T : Decodable {
        DispatchQueue.main.async {
            if let marsRoverModelInstance = decodableModel as? MarsRoverModel{
                self.marsRoverModel = marsRoverModelInstance
                
                if !marsRoverModelInstance.photos.isEmpty {
                    let minimumDate = Constants.dateFormatter.date(from: marsRoverModelInstance.photos[0].rover.landing_date)
                    let maximumDate = Constants.dateFormatter.date(from: marsRoverModelInstance.photos[0].rover.max_date)
                    
                    if let unwrappedMinimumDate = minimumDate, let unwrappedMaximumDate = maximumDate {
                        self.onDatePickerMinimumDateChange?(unwrappedMinimumDate)
                        self.onDatePickerMaximumDateChange?(unwrappedMaximumDate)
                    }
                    
                    self.marsRoversCameraOptions = marsRoverModelInstance.photos[0].rover.cameras
                }
            }
            
            self.onTableViewNeedsReload?()
        }
    }
    
    func onFail(with error: Error) {
        print(error)
    }
}
