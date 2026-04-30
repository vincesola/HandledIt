import SwiftUI

@main
struct HandledItApp: App {
    @StateObject private var store = HandledItStore()

    // TODO: Add the branded AppIcon asset in Assets.xcassets/AppIcon.appiconset from Xcode.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
