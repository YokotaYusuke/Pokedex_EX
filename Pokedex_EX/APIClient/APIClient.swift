import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
}

protocol APIClient {
    func execute<T: Request>(_ request: T) async -> Result<T.Response, APIError>
}

class HTTPAPIClient: APIClient {
    let http: Http
    
    init(http: Http = URLSession.shared) {
        self.http = http
    }
    
    func execute<T: Request>(_ request: T) async -> Result<T.Response, APIError> {
        do {
            let (data, response) = try await http.data(for: request.urlRequest)
            
            switch handleResponse(data, response) {
            case .success(let data):
                print("success!! \(T.Response.self)")
                let decoded = try JSONDecoder().decode(T.Response.self, from: data)
                return .success(decoded)
            case .failure(let error):
                return handleError(error)
            }
        } catch(let error) {
            print("error!! \(error.localizedDescription)")
            return handleError(error)
        }
    }
    
    private func handleResponse(_ data: Data, _ response: URLResponse) -> Result<Data, APIError> {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return .failure(APIError(reason: .badResponse))
        }
        if statusCode == 400 {
            return .failure(APIError(reason: .badResponse, code: statusCode))
        }
        return .success(data)
    }
    
    private func handleError<T: Decodable>(_ error: Error) -> Result<T, APIError> {
        if let urlError = error as? URLError {
            return .failure(
                APIError( reason: .network, code: urlError.errorCode)
            )
        }
        if let _ = error as? DecodingError {
            return .failure(APIError(reason: .decode))
        }
        return .failure(APIError(reason: .unknown))
    }
}


