import Foundation

protocol DecodableWithTypeHint: Decodable {
    var typeHint: NetworkTypeEnum { get }
}

enum NetworkTypeEnum {
    case APODModel
    case MarsRoverModel
}
