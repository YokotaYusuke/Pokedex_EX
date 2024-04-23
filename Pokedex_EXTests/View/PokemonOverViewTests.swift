@testable import Pokedex_EX
import XCTest
import Nimble
import Combine

class PokemonOverViewTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    func test_初期化時にPokemonRepositoyのgetPokemonを呼んでいるか() {
        let spyPokemonRepository = SpyPokemonRepository()
        
        
        _ = PokemonOverView.ViewModel(repository: spyPokemonRepository)
        
        
        expect(spyPokemonRepository.getPokemons_wasCalled).toEventually(beTrue())
    }
    
    func test_repositoryが返すポケモンの配列をパブリッシュする() {
        let stubPokemonRepository = StubPokemonRepository()
        stubPokemonRepository.getPokemons_return_value = [
            Pokemon(name: "pikachu"),
            Pokemon(name: "tanachu"),
        ]
        
        
        let viewModel = PokemonOverView.ViewModel(repository: stubPokemonRepository)
        
        
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
}
