import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: HandledItStore
    @State private var selectedTab = 0

    var body: some View {
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
                Label("Actions", systemImage: "checklist")
            }
            .tag(2)
        }
        .tint(.handledPrimary)
        .background(Color.handledBackground)
    }
}
