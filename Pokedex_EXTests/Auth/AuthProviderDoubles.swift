@testable import Pokedex_EX
import Foundation

class DummyAuthProvider: Authentication {
    @Published var userIsLogedIn: Bool = false
    var userIsLogedInPublisher: Published<Bool>.Publisher { $userIsLogedIn }
    
    func update(userIsLogedIn: Bool) {}
}

class FakeAuthProvider: Authentication {
    @Published var userIsLogedIn: Bool = false
    var userIsLogedInPublisher: Published<Bool>.Publisher { $userIsLogedIn }
    
    func update(userIsLogedIn: Bool) {
        self.userIsLogedIn = userIsLogedIn
    }
}
