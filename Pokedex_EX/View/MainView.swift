import SwiftUI
import Combine

struct MainView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        if ( viewModel.showLaunchView ) {
            ProgressView()
        } else if ( viewModel.showLoginView ) {
            LoginView(viewModel: .init(authProvider: viewModel.authProvider))
        } else {
            PokemonOverView(viewModel: .init(authProvider: viewModel.authProvider))
        }
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        var cancellables = Set<AnyCancellable>()
        let authProvider: Authentication
        let keychainProvider: Keychain
        @Published var showLaunchView: Bool = true
        @Published var showLoginView: Bool = false
        
        init(authProvider: Authentication, keychainProvider: Keychain = KeychainProvider()) {
            self.authProvider = authProvider
            self.keychainProvider = keychainProvider
            let token = keychainProvider.getItem(account: .accessToken, accessGroup: nil)
            
            Task { await update(showLoadingView: false) }
            
            if let token {
                authProvider.update(userIsLogedIn: true)
            } else {
                authProvider.update(userIsLogedIn: false)
            }
            
            authProvider.userIsLogedInPublisher
                .sink { userIsLogedIn in
                    DispatchQueue.main.async {
                        self.showLoginView = !userIsLogedIn
                    }
                }
                .store(in: &cancellables)
        }
        
        @MainActor
        func update(showLoadingView: Bool) async {
            self.showLaunchView = showLoadingView
        }
        
        @MainActor
        func update(showLoginView: Bool) async {
            self.showLoginView = showLoginView
        }
    }
}

#Preview {
    MainView(viewModel: .init(authProvider: AuthProvider()))
}
