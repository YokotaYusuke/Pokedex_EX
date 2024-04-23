import SwiftUI

struct PokemonOverView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        List(viewModel.pokemons, id: \.name) { pokemon in
            Text(pokemon.name)
        }
    }
}

extension PokemonOverView {
    class ViewModel: ObservableObject {
        @Published var pokemons = [Pokemon]()
        
        init(repository: PokemonRepository = DefaultPokemonRepository()) {
            Task {
                let pokemons = await repository.getPokemons()
                await update(pokemons)
            }
        }
        
        @MainActor
        func update(_ pokemons: [Pokemon]) {
            self.pokemons = pokemons
        }
    }
}


#Preview {
    PokemonOverView(viewModel: .init())
}
