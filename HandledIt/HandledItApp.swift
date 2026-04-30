import SwiftUI

@main
struct HandledItApp: App {
    @StateObject private var store = HandledItStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
