import Foundation

protocol PokemonRepository {
    func getPokemons() async -> [Pokemon]
    func getPokemonDetail(pokemonName: String) async throws -> PokemonDetail
    func postFavoritePokemon(token: String, name: String) async -> Result<String, APIError>
    func getFavoritePokemon(token: String, name: String) async -> Result<Bool, APIError>
}


class DefaultPokemonRepository: PokemonRepository {
    let http: Http
    let apiClient: APIClient
    
    init(http: Http = URLSession.shared, apiClient: APIClient = HTTPAPIClient()) {
        self.http = http
        self.apiClient = apiClient
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
    
    func postFavoritePokemon(token: String, name: String) async -> Result<String, APIError> {
        let request = PostFavoritePokemonRequest(name: name, token: token)
        return await apiClient.execute(request)
    }
    
    func getFavoritePokemon(token: String, name: String) async -> Result<Bool, APIError> {
        let request = GetFavoritePokemonRequest(name: name, token: token)
        let result = await apiClient.execute(request)
        switch result {
        case .success(let favorite):
            return .success(favorite.enabled)
        case .failure(let error):
            return .failure(error)
        }
    }
}

struct PostFavoritePokemonRequest: Request {
    typealias Response = String
    var url: URL { URL(string: "http://localhost:8080/api/pokemon/favorite")! }
    var method: Method = .post
    
    let name: String
    var params: [(String, String)]? { [("name", name)] }
    
    let token: String
    var headers: [String : String]? { ["Authorization": "Bearer \(token)"] }
    
    var body: Data?
}

struct GetFavoritePokemonRequest: Request {
    typealias Response = Favorite
    var url: URL { URL(string: "http://localhost:8080/api/pokemon/favorite")! }
    var method: Method = .get
    
    let name: String
    var params: [(String, String)]? { [("name", name)] }
    
    let token: String
    var headers: [String : String]? { ["Authorization": "Bearer \(token)"] }
    
    var body: Data?
}
