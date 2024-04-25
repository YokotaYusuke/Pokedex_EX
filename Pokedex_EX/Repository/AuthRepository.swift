import Foundation

protocol AuthRepository {
    func register(username: String, password: String) async -> Result<LoginResponse, APIError>
    func login(username: String, password: String) async -> Result<LoginResponse, APIError>
}

class DefaultAuthRepository: AuthRepository {
    let apiClient: APIClient
    
    init(apiClient: APIClient = HTTPAPIClient()) {
        self.apiClient = apiClient
    }
    
    func register(username: String, password: String) async -> Result<LoginResponse, APIError> {
        let body = AuthBody(username: username, password: password)
        let encoded = try? JSONEncoder().encode(body)
        let reqeust = RegisterReqeust(data: encoded)
        return await apiClient.execute(reqeust)
    }
    
    func login(username: String, password: String) async -> Result<LoginResponse, APIError> {
        let body = AuthBody(username: username, password: password)
        let encoded = try? JSONEncoder().encode(body)
        let request = LoginRequest(data: encoded)
        return await apiClient.execute(request)
    }
}

struct RegisterReqeust: Request {
    let data: Data?
    typealias Response = LoginResponse
    
    
    var url: URL = URL(string: "http://localhost:8080/api/register")!
    var method: Method = .post
    var params: [(String, String)]?
    var headers: [String : String]? = ["Content-Type": "application/json"]
    var body: Data? { data }
}

struct LoginRequest: Request {
    let data: Data?
    typealias Response = LoginResponse
    
    var url: URL = URL(string: "http://localhost:8080/api/login")!
    var method: Method = .post
    var params: [(String, String)]?
    var headers: [String : String]? = ["Content-Type": "application/json"]
    var body: Data? { data }
}
