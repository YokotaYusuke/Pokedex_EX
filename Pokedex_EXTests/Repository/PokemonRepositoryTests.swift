import XCTest
@testable import Pokedex_EX


class PokemonRepositoryTests: XCTestCase {
    func test_httpに正しいリクエストを渡す() async {
        let spyHttp = SpyHttp()
        let repository = DefaultPokemonRepository(http: spyHttp)
        
        
        _ = await repository.getPokemons()
        

        XCTAssertEqual(spyHttp.data_argument_request, URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!))
    }
    
    func test_httpが返すデータをデコードして返す() async throws {
        let pokeAPIResponse = """
        {
            "results": [
                {
                    "name": "pikachu"
                },
                {
                    "name": "tanachu"
                }
            ]
        }
        """
        let data = try XCTUnwrap(pokeAPIResponse.data(using: .utf8))
        let stubHttp = StubHttp()
        stubHttp.data_return_value = (data, HTTPURLResponse())
        let repository = DefaultPokemonRepository(http: stubHttp)
        
        
        let actualPokemons = await repository.getPokemons()
        
        
        XCTAssertEqual(actualPokemons.first?.name, "pikachu")
        XCTAssertEqual(actualPokemons.last?.name, "tanachu")
    }
}
