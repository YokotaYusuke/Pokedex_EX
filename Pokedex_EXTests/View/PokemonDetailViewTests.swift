@testable import Pokedex_EX
import XCTest
import Nimble
import Combine


class PokemonDetailViewTests: XCTestCase  {
    var cancellables = Set<AnyCancellable>()
    func test_初期化時にPokemonRepositoryのgetPokemonDetailを呼んでいる() {
        let spyPokemonRepository = SpyPokemonRepository()
        
        
        _ = PokemonDetailView.ViewModel(
            pokemon: Pokemon(name: "pikachu"),
            pokemonRepository: spyPokemonRepository,
            authProvider: DummyAuthProvider()
        )
        
        
        expect(spyPokemonRepository.getPokemonDetail_argument_pokemonName).toEventually(equal("pikachu"))
    }
    
    func test_PokemonRepositoryのgetPokemonDetailの返り値から_ポケモンの情報をパブリッシュする() {
        let stubPokemonRepository = StubPokemonRepository()
        stubPokemonRepository.getPokemonDetail_return_value = PokemonDetail(
            name: "pikachu",
            height: 10,
            weight: 50
        )
        
        
        let viewModel = PokemonDetailView.ViewModel(
            pokemon: Pokemon(name: ""),
            pokemonRepository: stubPokemonRepository,
            authProvider: DummyAuthProvider()
        )
        
        
        let expectation = XCTestExpectation()
        viewModel
            .$pokemonDetail
            .dropFirst()
            .sink { pokemonDetail in
                expect(pokemonDetail?.name).to(equal("pikachu"))
                expect(pokemonDetail?.height).to(equal(10))
                expect(pokemonDetail?.weight).to(equal(50))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_初期化時_pokemonRepository_getFavoritePokemonにトークンと名前を渡して呼ぶ() {
        let spyPokemonRepository = SpyPokemonRepository()
        let fakeAuthProvider = FakeAuthProvider()
        fakeAuthProvider.update(accessToken: "correct token")
        
        
        _ = PokemonDetailView.ViewModel(
            pokemon: Pokemon(name: "pikachu"),
            pokemonRepository: spyPokemonRepository,
            authProvider: fakeAuthProvider
        )
        
        
        expect(spyPokemonRepository.getFavoritePokemon_argument_token).toEventually(equal("correct token"))
        expect(spyPokemonRepository.getFavoritePokemon_argument_name).toEventually(equal("pikachu"))
    }
    
    func test_ポケモンをお気に入りしていたら_Starを塗りつぶす() {
        let stubPokemonRepository = StubPokemonRepository()
        stubPokemonRepository.getFavoritePokemon_returnValue = .success(true)
            
        
        let viewModel = PokemonDetailView.ViewModel(
            pokemon: Pokemon(name: "pikachu"),
            pokemonRepository: stubPokemonRepository,
            authProvider: DummyAuthProvider()
        )
        
        
        expect(viewModel.favoriteStarIsFil).toEventually(beTrue())
    }
    
    func test_ポケモンをお気に入りしていなかったら_Starを塗りつぶさない() {
        let stubPokemonRepository = StubPokemonRepository()
        stubPokemonRepository.getFavoritePokemon_returnValue = .success(false)
            
        
        let viewModel = PokemonDetailView.ViewModel(
            pokemon: Pokemon(name: "pocchama"),
            pokemonRepository: stubPokemonRepository,
            authProvider: DummyAuthProvider()
        )
        
        
        expect(viewModel.favoriteStarIsFil).toEventually(beFalse())
    }
    
    func test_ポケモンをお気に入りしたら_Starを塗りつぶし_repsitoryのpostFavoriteを呼ぶ() {
        let spyPokemonRepository = SpyPokemonRepository()
        let fakeAuthProvider = FakeAuthProvider()
        fakeAuthProvider.accessToken = "access token"
        let viewModel = PokemonDetailView.ViewModel(
            pokemon: Pokemon(name: "pikachu"),
            pokemonRepository: spyPokemonRepository,
            authProvider: fakeAuthProvider
        )
        
        
        viewModel.onTapFavoriteButton()
        
        
        expect(viewModel.favoriteStarIsFil).toEventually(beTrue())
        expect(spyPokemonRepository.postFavoritePokemon_argument_token)
            .toEventually(equal("access token"))
        expect(spyPokemonRepository.postFavoritePokemon_argument_name)
            .toEventually(equal("pikachu"))
    }
    
    func test_ポケモンのお気に入りを解除したら_Starの塗りつぶしを解除し_repositoryのpostFavoriteを呼ぶ() async {
        let viewModel = PokemonDetailView.ViewModel(
            pokemon: Pokemon(name: "pikachu"),
            pokemonRepository: DummyPokemonRepository(),
            authProvider: DummyAuthProvider()
        )
        
        try! await Task.sleep(nanoseconds: 10000000)
        viewModel.favoriteStarIsFil = true

        
        viewModel.onTapFavoriteButton()
        
        
        await expect(viewModel.favoriteStarIsFil).toEventually(beFalse())
    }
}
