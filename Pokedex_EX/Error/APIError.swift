import Foundation

struct APIError: Error {
    let reason: APIErrorReason
    let code: Int?
    
    init(
        reason: APIErrorReason,
        code: Int? = nil
    ) {
        self.reason = reason
        self.code = code
    }
    
    enum APIErrorReason {
        case badResponse
        case unauthorized
        case network
        case decode
        case unknown
    }
}
