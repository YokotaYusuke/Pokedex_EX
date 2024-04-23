import Foundation

protocol PokemonRepository {
    func getPokemons() async -> [Pokemon]
}


class DefaultPokemonRepository: PokemonRepository {
    let http: Http
    
    init(http: Http) {
        self.http = http
    }
    
    func getPokemons() async -> [Pokemon] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        do {
            let (data, _) = try await http.data(for: URLRequest(url: url))
            let decoded = try JSONDecoder().decode(PokeAPIResponse.self, from: data)
            return decoded.results
        } catch(let error) {
            return []
        }
    }
}
