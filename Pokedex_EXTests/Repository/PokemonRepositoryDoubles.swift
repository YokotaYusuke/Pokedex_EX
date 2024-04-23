import Foundation
@testable import Pokedex_EX

class DummyPokemonRepository: PokemonRepository {
    func getPokemonDetail(pokemonName: String) async throws -> Pokedex_EX.PokemonDetail {
        return PokemonDetail(name: "", height: 0, weight: 0)
    }
    
    func getPokemons() async -> [Pokemon] {
        return []
    }
}

class SpyPokemonRepository: PokemonRepository {
    var getPokemonDetail_argument_pokemonName: String? = nil
    func getPokemonDetail(pokemonName: String) async throws -> Pokedex_EX.PokemonDetail {
        getPokemonDetail_argument_pokemonName = pokemonName
        return PokemonDetail(name: "", height: 0, weight: 0)
    }
    
    var getPokemons_wasCalled: Bool = false
    func getPokemons() async -> [Pokemon] {
        getPokemons_wasCalled = true
        return []
    }
}

class StubPokemonRepository: PokemonRepository {
    var getPokemonDetail_return_value: PokemonDetail = PokemonDetail(name: "", height: 0, weight: 0)
    func getPokemonDetail(pokemonName: String) async throws -> Pokedex_EX.PokemonDetail {
        return getPokemonDetail_return_value
    }
    
    var getPokemons_return_value: [Pokemon] = []
    func getPokemons() async -> [Pokemon] {
        return getPokemons_return_value
    }
}
