import Foundation
@testable import Pokedex_EX

class SpyAPIClient: APIClient {
    var execute_argument_request: (any Request)? = nil
    func execute<T>(_ request: T) async -> Result<T.Response, APIError> where T : Request {
        execute_argument_request = request
        return .failure(APIError(reason: .badResponse))
    }
}

class StubAPIClient<R: Decodable>: APIClient {
    var execute_returnValue: Result<R, APIError> = .failure(APIError(reason: .unknown))
    func execute<T>(_ request: T) async -> Result<T.Response, APIError> where T : Request {
        return execute_returnValue as! Result<T.Response, APIError>
    }
}
