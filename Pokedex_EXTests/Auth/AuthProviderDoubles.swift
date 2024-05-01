@testable import Pokedex_EX
import Foundation

class DummyAuthProvider: Authentication {
    @Published var userIsLogedIn: Bool = false
    var userIsLogedInPublisher: Published<Bool>.Publisher { $userIsLogedIn }
    
    @Published var accessToken: String? = "token"
    var accessTokenPublisher: Published<String?>.Publisher { $accessToken }
    
    func update(userIsLogedIn: Bool) {}
    
    func update(accessToken: String?) {}
}

class FakeAuthProvider: Authentication {
    @Published var userIsLogedIn: Bool = false
    var userIsLogedInPublisher: Published<Bool>.Publisher { $userIsLogedIn }
    
    @Published var accessToken: String? = nil
    var accessTokenPublisher: Published<String?>.Publisher { $accessToken }
    
    func update(userIsLogedIn: Bool) {
        self.userIsLogedIn = userIsLogedIn
    }
    
    // Todo: should make test!!
    func update(accessToken: String?) {
        self.accessToken = accessToken
    }
}
