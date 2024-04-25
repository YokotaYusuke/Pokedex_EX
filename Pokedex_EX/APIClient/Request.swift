import Foundation

protocol Request {
    associatedtype Response: Decodable
    var url: URL { get }
    var method: Method { get }
    var params: [(String, String)]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension Request {
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(url: self.url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = self.params?.map { URLQueryItem(name: $0.0, value: $0.1) }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = self.method.rawValue
        self.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = body
        return urlRequest
    }
}
