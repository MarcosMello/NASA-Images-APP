import Foundation

struct MarsRoverCameraModel: Codable {
    let name: String
    let full_name: String
}

struct MarsRoverImagesModel: Codable{
    let earth_date: String
    let img_src: String
    
    let camera: MarsRoverCameraModel
}

struct MarsRoverModel: DecodableWithTypeHint{
    var typeHint: NetworkTypeEnum = NetworkTypeEnum.MarsRoverModel
    
    let images: [MarsRoverImagesModel]
    
    private enum CodingKeys: String, CodingKey {
        case images
    }
}
