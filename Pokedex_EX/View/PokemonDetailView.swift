import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text(viewModel.pokemonDetail?.name ?? "")
            Text(viewModel.pokemonDetail?.height.description ?? "")
            Text(viewModel.pokemonDetail?.weight.description ?? "")
            Button {
                viewModel.onTapFavoriteButton()
            } label: {
                Image(systemName: viewModel.favoriteStarIsFil ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension PokemonDetailView {
    class ViewModel: ObservableObject {
        @Published var pokemonDetail: PokemonDetail?
        @Published var favoriteStarIsFil: Bool = false
        let pokemonRepository: PokemonRepository
        let authProvider: Authentication
        let name: String
        
        init(
            pokemon: Pokemon,
            pokemonRepository: PokemonRepository = DefaultPokemonRepository(),
            authProvider: Authentication
        ) {
            self.name = pokemon.name
            self.pokemonRepository = pokemonRepository
            self.authProvider = authProvider
            Task {
                let pokemonDetail = try? await pokemonRepository.getPokemonDetail(pokemonName: pokemon.name)
                await update(pokemonDetail)
                if let accessToken = authProvider.accessToken {
                    let result = await pokemonRepository.getFavoritePokemon(token: accessToken, name: pokemon.name)
                    
                    switch result {
                    case .success(let isFavorite):
                        favoriteStarIsFil = isFavorite
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        func onTapFavoriteButton() {
            self.favoriteStarIsFil = !self.favoriteStarIsFil
            Task {
                guard let accessToken = authProvider.accessToken else { return }
                _ = await pokemonRepository.postFavoritePokemon(
                    token: accessToken,
                    name: name
                )
            }
        }
        
        @MainActor
        func update(_ pokemonDetail: PokemonDetail?) {
            self.pokemonDetail = pokemonDetail
        }
    }
}

#Preview {
    PokemonDetailView(
        viewModel: .init(pokemon: Pokemon(name: "pikachu"), authProvider: AuthProvider())
    )
}
