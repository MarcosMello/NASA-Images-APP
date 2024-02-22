import Foundation

struct APODModel: Encodable, DecodableWithTypeHint{
    let typeHint: NetworkTypeEnum = NetworkTypeEnum.APODModel
    
    let title: String
    let explanation: String
    let date: String
    
    let url: String
    let hdurl: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, explanation, date
        case url, hdurl
    }
}
