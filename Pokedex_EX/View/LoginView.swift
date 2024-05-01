import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        
        Text("Hello, World!")
        VStack {
            TextField("ユーザー名", text: $viewModel.username)
            SecureField("パスワード", text: $viewModel.password)
            Button("ログイン") {
                Task {
                    await viewModel.onTapLoginButton()
                }
            }
            Button("アカウント作成") {
                Task {
                    await viewModel.onTapRegisterButton()
                }
            }
        }
    }
}

extension LoginView {
    class ViewModel: ObservableObject {
        let authRepository: AuthRepository
        let authProvider: Authentication
        let keychainProvider: Keychain
        @Published var username: String = ""
        @Published var password: String = ""
        
        init(
            authRepository: AuthRepository = DefaultAuthRepository(),
            authProvider: Authentication,
            keychainProvider: Keychain = KeychainProvider()
        ) {
            self.authRepository = authRepository
            self.authProvider = authProvider
            self.keychainProvider = keychainProvider
        }
        
        func onTapLoginButton() async {
            let result = await authRepository.login(username: username, password: password)
            switch result {
            case .success(let loginResponse):
                keychainProvider.saveItem(account: .accessToken, item: loginResponse.token, accessGroup: nil)
                authProvider.update(userIsLogedIn: true)
                authProvider.update(accessToken: loginResponse.token)
            case .failure(let error):
                print()
            }
        }
        
        func onTapRegisterButton() async {
            let result = await authRepository.register(username: username, password: password)
            switch result {
            case .success(let loginResponse):
                keychainProvider.saveItem(account: .accessToken, item: loginResponse.token, accessGroup: nil)
                authProvider.update(userIsLogedIn: true)
                authProvider.update(accessToken: loginResponse.token)
            case .failure(let error):
                print()
            }
        }
    }
}

#Preview {
    LoginView(viewModel: .init(authProvider: AuthProvider()))
}
