import UIKit

class MarsRoverViewModel {
    let endpoint: String = "mars-photos/api/v1/rovers/curiosity/photos"
    
    var networkingManager: NetworkingManager<MarsRoverModel>
    
    var model: MarsRoverModel?
    var error: NetworkingManagerError?
    
    var marsRoverImages: [MarsRoverImagesModel]? {
        return self.model?.photos
    }
    var marsRoverImagesLength: Int {
        return self.marsRoverImages?.count ?? 0
    }
    
    var marsRoversCameraOptions : [MarsRoverCameraModel]? {
        return self.model?.photos.first?.rover.cameras
    }
    var marsRoversCameras: [MarsRoverCameraModel]? {
        return [Constants.marsRoverAllCamerasOption] + (marsRoversCameraOptions ?? [])
    }
    var marsRoversCamerasLength: Int {
        return self.marsRoversCameras?.count ?? 0
    }
    
    var minimumDate: Date? {
        let stringDate: String? = model?.photos.first?.rover.landing_date
        
        guard let stringDate = stringDate else {
            return nil
        }
        
        return Constants.dateFormatter.date(from: stringDate)
    }
    var maximumDate: Date? {
        let stringDate: String? = model?.photos.first?.rover.max_date
        
        guard let stringDate = stringDate else {
            return nil
        }
        
        return Constants.dateFormatter.date(from: stringDate)
    }
    
    var page: Int = 1
    var pageIndicator: String {
        return "Página \(self.page)"
    }
    
    init(with networkingManager: NetworkingManager<MarsRoverModel>){
        self.networkingManager = networkingManager
    }
    
    func updatePageIndicator(with updateAmount: Int){
        self.page = self.page + updateAmount > 0 ? self.page + updateAmount : 1
    }
    
    func getDataFromAPI(earthDate: Date? = nil, camera: String? = nil, sol: Int? = nil, page: Int, completion: @escaping (Bool) -> Void){
        var queryParameters: [String] = []

        queryParameters = ["page=\(self.page)"]
        
        if let selectedSol = sol {
            queryParameters.append("sol=\(selectedSol)")
        }
        
        if let selectedEarthDate = earthDate {
            queryParameters.append("earth_date=\(selectedEarthDate)")
        }
        
        if let selectedCamera = camera {
            if (selectedCamera != Constants.allCamerasOption) {
                queryParameters.append("camera=\(selectedCamera)")
            }
        }
        
        networkingManager.getTask(endpoint: endpoint, queryParameters: queryParameters) { result in
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
