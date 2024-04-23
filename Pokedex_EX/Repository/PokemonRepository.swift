import Foundation

protocol PokemonRepository {
    func getPokemons() async -> [Pokemon]
    func getPokemonDetail(pokemonName: String) async throws -> PokemonDetail
}


class DefaultPokemonRepository: PokemonRepository {
    let http: Http
    
    init(http: Http = URLSession.shared) {
        self.http = http
    }
    
    func getPokemons() async -> [Pokemon] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        do {
            let (data, _) = try await http.data(for: URLRequest(url: url))
            let decoded = try JSONDecoder().decode(PokeAPIResponse.self, from: data)
            return decoded.results
        } catch {
            return []
        }
    }
    
    func getPokemonDetail(pokemonName: String) async throws -> PokemonDetail {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)")!
        let (data, _) = try await http.data(for: URLRequest(url: url))
        let decoded = try JSONDecoder().decode(PokemonDetail.self, from: data)
        return decoded
    }
    
    struct GetPokemonDetailError: Error {
        
    }
}
