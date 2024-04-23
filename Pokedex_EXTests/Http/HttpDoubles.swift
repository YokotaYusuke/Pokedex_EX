@testable import Pokedex_EX
import Foundation

class SpyHttp: Http {
    var data_argument_request: URLRequest? = nil
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        data_argument_request = request
        return (Data(), HTTPURLResponse())
    }
}

class StubHttp: Http {
    var data_return_value: (Data, URLResponse) = (Data(), HTTPURLResponse())
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return data_return_value
    }
}
