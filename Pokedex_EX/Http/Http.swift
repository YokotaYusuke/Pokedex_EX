import Foundation


protocol Http {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: Http {}
