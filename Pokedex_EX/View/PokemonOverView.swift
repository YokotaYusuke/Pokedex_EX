import SwiftUI

struct PokemonOverView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        NavigationStack {
            Button("ログアウト") {
                viewModel.onTapLogoutButton()
            }
            List(viewModel.pokemons, id: \.name) { pokemon in
                NavigationLink {
                    PokemonDetailView(
                        viewModel: .init(pokemon: pokemon, authProvider: viewModel.authProvider)
                    )
                } label: {
                    Text(pokemon.name)
                }
            }
            .navigationTitle("Pokedex")
        }
    }
}

extension PokemonOverView {
    class ViewModel: ObservableObject {
        @Published var pokemons = [Pokemon]()
        let authProvider: Authentication
        let keychainProvider: Keychain
        
        init(
            repository: PokemonRepository = DefaultPokemonRepository(),
            authProvider: Authentication,
            keychainProvider: Keychain = KeychainProvider()
        ) {
            self.authProvider = authProvider
            self.keychainProvider = keychainProvider
            
            Task {
                let pokemons = await repository.getPokemons()
                await update(pokemons)
            }
        }
        
        func onTapLogoutButton() {
            authProvider.update(userIsLogedIn: false)
            keychainProvider.deleteItem(account: .accessToken, accessGroup: nil)
        }
        
        @MainActor
        func update(_ pokemons: [Pokemon]) {
            self.pokemons = pokemons
        }
    }
}


#Preview {
    PokemonOverView(viewModel: .init(authProvider: AuthProvider()))
}
