import XCTest
@testable import Pokedex_EX
import Nimble

class PokemonRepositoryTests: XCTestCase {
    func test_getPokemons_httpに正しいリクエストを渡す() async {
        let spyHttp = SpyHttp()
        let repository = DefaultPokemonRepository(http: spyHttp)
        
        
        _ = await repository.getPokemons()
        

        XCTAssertEqual(spyHttp.data_argument_request, URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!))
    }
    
    func test_getPokemons_httpが返すデータをデコードして返す() async throws {
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
    
    func test_getPokemonDetail_httpに正しいリクエストを渡す() async {
        let spyHttp = SpyHttp()
        let repository = DefaultPokemonRepository(http: spyHttp)
        
        
        _ = try? await repository.getPokemonDetail(pokemonName: "tanachu")
        
        
        expect(spyHttp.data_argument_request)
            .to(equal(URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon/tanachu")!)))
    }
    
    func test_getPokemonDetail_httpが返すデータをデコードして返す() async throws {
        let pokeAPIResponse = """
        {
            "name": "pikachu",
            "height": 10,
            "weight": 20
        }
        """
        let data = try XCTUnwrap(pokeAPIResponse.data(using: .utf8))
        let stubHttp = StubHttp()
        stubHttp.data_return_value = (data, HTTPURLResponse())
        let repository = DefaultPokemonRepository(http: stubHttp)
        
        
        let actualPokemonDetail = try? await repository.getPokemonDetail(pokemonName: "")
        
        
        XCTAssertEqual(actualPokemonDetail?.name, "pikachu")
        XCTAssertEqual(actualPokemonDetail?.height, 10)
        XCTAssertEqual(actualPokemonDetail?.weight, 20)
    }
}
