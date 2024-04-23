import Foundation
@testable import Pokedex_EX

class DummyPokemonRepository: PokemonRepository {
    func getPokemons() async -> [Pokemon] {
        return []
    }
}

class SpyPokemonRepository: PokemonRepository {
    var getPokemons_wasCalled: Bool = false
    func getPokemons() async -> [Pokemon] {
        getPokemons_wasCalled = true
        return []
    }
}

class StubPokemonRepository: PokemonRepository {
    var getPokemons_return_value: [Pokemon] = []
    func getPokemons() async -> [Pokemon] {
        return getPokemons_return_value
    }
}
