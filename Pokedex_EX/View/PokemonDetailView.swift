import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text(viewModel.pokemonDetail?.name ?? "")
            Text(viewModel.pokemonDetail?.height.description ?? "")
            Text(viewModel.pokemonDetail?.weight.description ?? "")
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension PokemonDetailView {
    class ViewModel: ObservableObject {
        @Published var pokemonDetail: PokemonDetail?
        
        init(pokemon: Pokemon, pokemonRepository: PokemonRepository = DefaultPokemonRepository()) {
            Task {
                let pokemonDetail = try? await pokemonRepository.getPokemonDetail(pokemonName: pokemon.name)
                await update(pokemonDetail)
            }
        }
        
        @MainActor
        func update(_ pokemonDetail: PokemonDetail?) {
            self.pokemonDetail = pokemonDetail
        }
    }
}

#Preview {
    PokemonDetailView(viewModel: .init(pokemon: Pokemon(name: "pikachu")))
}
