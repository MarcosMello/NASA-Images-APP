import Foundation

enum NetworkingManagerError: Error {
    case baseUrlIsNIL
    case urlCouldNotBeFormed
    case requestError(error: Error)
    case dataIsNIL
    case responseCouldNotBeParsed
}

struct NetworkingManager<T: Decodable> {
    let baseURL: String?
    
    func prepareURL(endpoint: String, queryParameters: [String]? = nil) -> String? {
        guard var unwrappedURL = self.baseURL else {
            return nil
        }
        
        unwrappedURL += "\(endpoint)?api_key=\(Constants.nasaApiKey)"
        
        if let unwrappedQueryParameters = queryParameters {
            unwrappedURL += "&" + unwrappedQueryParameters.joined(separator: "&")
        }

        return unwrappedURL
    }
    
    func getTask(endpoint: String, queryParameters: [String]? = nil, completion: @escaping (Result<T, NetworkingManagerError>) -> Void) {
        guard let urlString = prepareURL(endpoint: endpoint, queryParameters: queryParameters) else {
            completion(.failure(NetworkingManagerError.baseUrlIsNIL))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingManagerError.urlCouldNotBeFormed))
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(NetworkingManagerError.requestError(error: error ?? NetworkingManagerError.dataIsNIL)))
                return
            }
            
            guard let unwrappedData = data else {
                completion(.failure(NetworkingManagerError.dataIsNIL))
                return
            }
            
            guard let apiResponse = self.parseJSON(unwrappedData) else {
                completion(.failure(NetworkingManagerError.responseCouldNotBeParsed))
                return
            }
            
            completion(.success(apiResponse))
        }
        
        task.resume()
    }
    
    func parseJSON(_ apiResponse: Data) -> T? {        
        do {
            return try JSONDecoder().decode(T.self, from: apiResponse)
        } catch {
            return nil
        }
    }
}
