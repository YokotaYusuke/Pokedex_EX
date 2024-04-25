@testable import Pokedex_EX
import XCTest
import Nimble

class FakeAuthProviderTests: XCTestCase {
    func test_update_ユーザーのログイン状態を更新できる() async {
        let fakeAuthProvider = FakeAuthProvider()
        
        
        await fakeAuthProvider.update(userIsLogedIn: true)
        expect(fakeAuthProvider.userIsLogedIn).to(beTrue())
        
        
        await fakeAuthProvider.update(userIsLogedIn: false)
        expect(fakeAuthProvider.userIsLogedIn).to(beFalse())
    }
}
