import SwiftUI
  
struct ContentView: View {
    @EnvironmentObject var authProvider: AuthProvider
    
    var body: some View {
        MainView(viewModel: .init(authProvider: authProvider))
    }
}

#Preview {
    ContentView()
}
