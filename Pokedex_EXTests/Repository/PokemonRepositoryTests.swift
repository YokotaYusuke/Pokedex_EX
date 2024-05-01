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
    
    func test_postFavoritePokemon_httpに正しいリクエストを渡す() async {
        let spyApiClient = SpyAPIClient()
        let repository = DefaultPokemonRepository(apiClient: spyApiClient)
        
        
        _ = await repository.postFavoritePokemon(token: "correct token", name: "pikachu")
        
        
        expect(spyApiClient.execute_argument_request?.url.absoluteString)
            .to(equal("http://localhost:8080/api/pokemon/favorite"))
        expect(spyApiClient.execute_argument_request?.method).to(equal(Method.post))
        expect(spyApiClient.execute_argument_request?.params).to(equal([("name", "pikachu")]))
        expect(spyApiClient.execute_argument_request?.headers).to(equal(["Authorization": "Bearer correct token"]))
    }
    
    func test_postFavoritePokemon_httpの返り値を返す() async {
        let stubAPIClient = StubAPIClient<String>()
        stubAPIClient.execute_returnValue = .success("some pokemon id")
        let repository = DefaultPokemonRepository(apiClient: stubAPIClient)
        
        
        let result = await repository.postFavoritePokemon(token: "", name: "")
        
        
        expect(result).to(beSuccess { pokemonId in
            expect(pokemonId).to(equal("some pokemon id"))
        })
    }
    
    func test_getFavoritePokemon_httpに正しいリクエストを渡す() async {
        let spyApiClient = SpyAPIClient()
        let repository = DefaultPokemonRepository(apiClient: spyApiClient)
        
        
        _ = await repository.getFavoritePokemon(token: "correct token", name: "pikachu")
        
        
        expect(spyApiClient.execute_argument_request?.url.absoluteString)
            .to(equal("http://localhost:8080/api/pokemon/favorite"))
        expect(spyApiClient.execute_argument_request?.method).to(equal(Method.get))
        expect(spyApiClient.execute_argument_request?.params).to(equal([("name", "pikachu")]))
        expect(spyApiClient.execute_argument_request?.headers).to(equal(["Authorization": "Bearer correct token"]))
    }
    
    func test_getFavoritePokemon_apiclientの返り値を返す() async {
        let stubApiClient = StubAPIClient<Favorite>()
        stubApiClient.execute_returnValue = .success(Favorite(enabled: true))
        let repository = DefaultPokemonRepository(apiClient: stubApiClient)
        
        
        let result = await repository.getFavoritePokemon(token: "", name: "")
        
        
        expect(result).to(beSuccess { isFavorite in
            expect(isFavorite).to(beTrue())
        })
    }
}
