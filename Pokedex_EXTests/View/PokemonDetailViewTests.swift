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
            pokemonRepository: spyPokemonRepository
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
            pokemonRepository: stubPokemonRepository
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
}
