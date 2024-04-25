import Foundation

protocol Authentication {
    var userIsLogedInPublisher: Published<Bool>.Publisher { get }
    func update(userIsLogedIn: Bool)
}

class AuthProvider: ObservableObject, Authentication {
    @Published var userIsLogedIn: Bool = false
    var userIsLogedInPublisher: Published<Bool>.Publisher { $userIsLogedIn }
    
    func update(userIsLogedIn: Bool) {
        DispatchQueue.main.async {
            self.userIsLogedIn = userIsLogedIn
        }
    }
}
