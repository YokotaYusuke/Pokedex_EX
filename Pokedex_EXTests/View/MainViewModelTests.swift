@testable import Pokedex_EX
import XCTest
import Nimble

class MainViewModelTests: XCTestCase {
    // 初期化時はローディング画面を表示する
    func test_初期化時はローンチ画面を表示する() {
        let viewModel = MainView.ViewModel(
            authProvider: DummyAuthProvider(),
            keychainProvider: DummyKeychainProvider()
        )
        
        
        expect(viewModel.showLaunchView).to(beTrue())
    }
    
    func test_初期化時にKeychainからトークンを取得するメソッドを呼ぶ() {
        let spyKeychainProbider = SpyKeychainProvider()
        
        
        _ = MainView.ViewModel(
            authProvider: DummyAuthProvider(),
            keychainProvider: spyKeychainProbider
        )
        
    
        expect(spyKeychainProbider.getItem_argument_account).to(equal(.accessToken))
    }
    
    func test_keychainにトークンがすでにある場合_ローンチ画面を非表示にし_コンテンツを表示する() {
        let stubKeychainProvider = StubKeychainProvider()
        stubKeychainProvider.getItem_returnValue = "token is already exists"
        
        
        let viewModel = MainView.ViewModel(
            authProvider: FakeAuthProvider(),
            keychainProvider: stubKeychainProvider
        )
        
        
        expect(viewModel.showLaunchView).toEventually(beFalse())
        expect(viewModel.showLoginView).toEventually(beFalse())
    }
    
    func test_keychainにトークンがない（nil）の場合_ログイン画面を表示する() {
        let stubKeychainProvider = StubKeychainProvider()
        stubKeychainProvider.getItem_returnValue = nil
        
        
        let viewModel = MainView.ViewModel(
            authProvider: FakeAuthProvider(),
            keychainProvider: stubKeychainProvider
        )
        
        
        expect(viewModel.showLaunchView).toEventually(beFalse())
        expect(viewModel.showLoginView).toEventually(beTrue())
    }
    
    func test_ログインが完了したらコンテンツを表示する() {
        let fakeAuthProvider = FakeAuthProvider()
        let viewModel = MainView.ViewModel(
            authProvider: fakeAuthProvider,
            keychainProvider: DummyKeychainProvider()
        )
        
        
        fakeAuthProvider.userIsLogedIn = true
        
        
        expect(viewModel.showLaunchView).toEventually(beFalse())
        expect(viewModel.showLoginView).toEventually(beFalse())
    }
}
