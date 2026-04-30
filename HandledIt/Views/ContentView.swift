import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Color.handledBackground
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                NavigationStack {
                    InboxView()
                }
                .tabItem {
                    Label("Inbox", systemImage: "tray.full")
                }
                .tag(0)

                NavigationStack {
                    TimelineView()
                }
                .tabItem {
                    Label("Timeline", systemImage: "calendar")
                }
                .tag(1)

                NavigationStack {
                    ActionsView()
                }
                .tabItem {
                    Label("Actions", systemImage: "checkmark.circle")
                }
                .tag(2)
            }
            .tint(.handledPrimary)
        }
    }
}
