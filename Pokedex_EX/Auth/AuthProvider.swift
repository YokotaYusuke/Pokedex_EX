import Foundation

protocol Authentication {
    var userIsLogedInPublisher: Published<Bool>.Publisher { get }
    var accessToken: String? { get set }
    func update(userIsLogedIn: Bool)
    func update(accessToken: String?)
}

class AuthProvider: ObservableObject, Authentication {
    @Published var userIsLogedIn: Bool = false
    var userIsLogedInPublisher: Published<Bool>.Publisher { $userIsLogedIn }
    
    @Published var accessToken: String? = nil
    var accessTokenPublisher: Published<String?>.Publisher { $accessToken }
    
    func update(userIsLogedIn: Bool) {
        DispatchQueue.main.async {
            self.userIsLogedIn = userIsLogedIn
        }
    }
    
    func update(accessToken: String?) {
        DispatchQueue.main.async {
            self.accessToken = accessToken
        }
    }
}
