@testable import Pokedex_EX
import XCTest
import Nimble
import Combine

class PokemonOverViewTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    func test_初期化時にPokemonRepositoyのgetPokemonを呼んでいるか() {
        let spyPokemonRepository = SpyPokemonRepository()
        
        
        _ = build(repository: spyPokemonRepository)
        
        
        expect(spyPokemonRepository.getPokemons_wasCalled).toEventually(beTrue())
    }
    
    func test_repositoryが返すポケモンの配列をパブリッシュする() {
        let stubPokemonRepository = StubPokemonRepository()
        stubPokemonRepository.getPokemons_return_value = [
            Pokemon(name: "pikachu"),
            Pokemon(name: "tanachu"),
        ]
        
        
        let viewModel = build(repository: stubPokemonRepository)
        
        
        let expectation = XCTestExpectation()
        viewModel
            .$pokemons
            .dropFirst()
            .sink { pokemons in
                expect(pokemons.first?.name).to(equal("pikachu"))
                expect(pokemons.last?.name).to(equal("tanachu"))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ログアウトボタンをタップした時にトークンを削除してログイン画面に遷移する() {
        let fakeAuthProvider = FakeAuthProvider()
        let spyKeychainProvider = SpyKeychainProvider()
        let viewModel = build(
            authProvider: fakeAuthProvider,
            keychainProvider: spyKeychainProvider
        )
        fakeAuthProvider.userIsLogedIn = true
        
        
        viewModel.onTapLogoutButton()
        
        
        expect(fakeAuthProvider.userIsLogedIn).to(beFalse())
        expect(spyKeychainProvider.deleteItem_argument_account)
            .to(equal(.accessToken))
    }
}

extension PokemonOverViewTests {
    func build(
        repository: PokemonRepository = DummyPokemonRepository(),
        authProvider: Authentication = DummyAuthProvider(),
        keychainProvider: Keychain = DummyKeychainProvider()
    ) -> PokemonOverView.ViewModel {
        return .init(
            repository: repository,
            authProvider: authProvider,
            keychainProvider: keychainProvider
        )
    }
}
