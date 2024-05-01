import Foundation
@testable import Pokedex_EX

class DummyPokemonRepository: PokemonRepository {
    
    func getPokemonDetail(pokemonName: String) async throws -> PokemonDetail {
        return PokemonDetail(name: "", height: 0, weight: 0)
    }
    
    func getPokemons() async -> [Pokemon] {
        return []
    }
    
    func postFavoritePokemon(token: String, name: String) async -> Result<String, APIError> {
        return .failure(APIError(reason: .unknown))
    }
    
    func getFavoritePokemon(token: String, name: String) async -> Result<Bool, APIError> {
        return .success(true)
    }
}

class SpyPokemonRepository: PokemonRepository {
    var getPokemonDetail_argument_pokemonName: String? = nil
    func getPokemonDetail(pokemonName: String) async throws -> PokemonDetail {
        getPokemonDetail_argument_pokemonName = pokemonName
        return PokemonDetail(name: "", height: 0, weight: 0)
    }
    
    var getPokemons_wasCalled: Bool = false
    func getPokemons() async -> [Pokemon] {
        getPokemons_wasCalled = true
        return []
    }
    
    var postFavoritePokemon_argument_token: String? = nil
    var postFavoritePokemon_argument_name: String? = nil
    func postFavoritePokemon(token: String, name: String) async -> Result<String, APIError> {
        postFavoritePokemon_argument_token = token
        postFavoritePokemon_argument_name = name
        return .failure(APIError(reason: .unknown))
    }
    
    var getFavoritePokemon_argument_token: String? = nil
    var getFavoritePokemon_argument_name: String? = nil
    func getFavoritePokemon(token: String, name: String) async -> Result<Bool, APIError> {
        getFavoritePokemon_argument_token = token
        getFavoritePokemon_argument_name = name
        return .success(true)
    }
}

class StubPokemonRepository: PokemonRepository {
    var getPokemonDetail_return_value: PokemonDetail = PokemonDetail(name: "", height: 0, weight: 0)
    func getPokemonDetail(pokemonName: String) async throws -> PokemonDetail {
        return getPokemonDetail_return_value
    }
    
    var getPokemons_return_value: [Pokemon] = []
    func getPokemons() async -> [Pokemon] {
        return getPokemons_return_value
    }
    
    var postFavoritePokemon_returnValue: Result<String, APIError> = .failure(APIError(reason: .unknown))
    func postFavoritePokemon(token: String, name: String) async -> Result<String, APIError> {
        return postFavoritePokemon_returnValue
    }
    
    
    var getFavoritePokemon_returnValue: Result<Bool, APIError> = .failure(APIError(reason: .unknown))
    func getFavoritePokemon(token: String, name: String) async -> Result<Bool, APIError> {
        return getFavoritePokemon_returnValue
    }
}
