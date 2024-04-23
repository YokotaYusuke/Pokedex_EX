import SwiftUI
  
struct ContentView: View {
    var body: some View {
        PokemonOverView(viewModel: .init())
    }
}

#Preview {
    ContentView()
}
