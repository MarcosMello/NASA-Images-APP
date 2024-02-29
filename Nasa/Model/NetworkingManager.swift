import Foundation

enum NetworkingManagerError: Error {
    case baseUrlIsNIL
    case urlCouldBeFormed
    case requestError(error: Error)
    case dataIsNIL
    case responseCouldNotBeParsed
}

protocol NetworkingManagerDelegate {
    func onSuccess<T>(_ networkingMaganer: NetworkingManager<T>, with decodableModel: Decodable)
    func onFail(with error: Error)
}

struct NetworkingManager<T: Decodable> {
    let baseURL: String?
    
    var delegate: NetworkingManagerDelegate?
    
    func prepareURL(endpoint: String, apiKey: String, queryParameters: [String]? = nil) -> String? {
        guard var unwrappedURL = self.baseURL else {
            delegate?.onFail(with: NetworkingManagerError.baseUrlIsNIL)
            return nil
        }
        
        unwrappedURL += "\(endpoint)?api_key=\(apiKey)"
        
        if let unwrappedQueryParameters = queryParameters {
            unwrappedURL += "&" + unwrappedQueryParameters.joined(separator: "&")
        }

        return unwrappedURL
    }
    
    func getTask(with urlString: String) {
        guard let url = URL(string: urlString) else {
            delegate?.onFail(with: NetworkingManagerError.urlCouldBeFormed)
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let unwrappedError = error {
                delegate?.onFail(with: NetworkingManagerError.requestError(error: unwrappedError))
                return
            }
            
            guard let unwrappedData = data else {
                delegate?.onFail(with: NetworkingManagerError.dataIsNIL)
                return
            }
            
            guard let apiResponse = self.parseJSON(unwrappedData) else {
                delegate?.onFail(with: NetworkingManagerError.responseCouldNotBeParsed)
                return
            }
            
            delegate?.onSuccess(self, with: apiResponse)
        }
        
        task.resume()
    }
    
    func parseJSON(_ apiResponse: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: apiResponse)
        } catch {
            delegate?.onFail(with: error)
            return nil
        }
    }
}
