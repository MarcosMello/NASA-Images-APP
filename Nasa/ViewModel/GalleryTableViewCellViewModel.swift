import UIKit

class GalleryTableViewCellViewModel {
    private let img_src: String?
    let cameraName: String?
    let earth_date: String?
    
    var img_url: URL? {
        if let urlString = self.img_src,
           let url = URL(string: urlString),
           var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            comps.scheme = "https"
            
            if let safeURL = comps.url {
                return safeURL
            }
        }
        
        return nil
    }
    
    var descriptionLabelText: String {
        return "\(self.cameraName ?? "") @ \(self.earth_date ?? "")"
    }
    
    init(with marsRoverImagesModel: MarsRoverImagesModel?) {
        self.img_src = marsRoverImagesModel?.img_src
        self.cameraName = marsRoverImagesModel?.camera.name
        self.earth_date = marsRoverImagesModel?.earth_date
    }
}
