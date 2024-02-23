import Foundation

struct MarsRoverCameraModel: Codable {
    let name: String
    let full_name: String
}

struct MarsRoverInfo: Codable {
    let name: String
    let landing_date: String
    let max_date: String
    
    let cameras: [MarsRoverCameraModel]
}

struct MarsRoverImagesModel: Codable{
    let earth_date: String
    let img_src: String
    
    let camera: MarsRoverCameraModel
    
    let rover: MarsRoverInfo
}

struct MarsRoverModel: DecodableWithTypeHint{
    var typeHint: NetworkTypeEnum = NetworkTypeEnum.MarsRoverModel
    
    let photos: [MarsRoverImagesModel]
    
    private enum CodingKeys: String, CodingKey {
        case photos
    }
}
