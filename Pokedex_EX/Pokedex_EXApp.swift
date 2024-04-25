import SwiftUI

@main
struct Pokedex_EXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthProvider())
        }
    }
}
