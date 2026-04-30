import SwiftUI

struct ContentView: View {
    @ObservedObject var inboxViewModel: InboxViewModel
    @ObservedObject var timelineViewModel: TimelineViewModel
    @ObservedObject var actionsViewModel: ActionsViewModel

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                InboxView(viewModel: inboxViewModel) {
                    selectedTab = 1
                }
            }
            .tabItem {
                Label("Inbox", systemImage: "tray.full")
            }
            .tag(0)

            NavigationStack {
                TimelineView(viewModel: timelineViewModel) {
                    selectedTab = 2
                }
            }
            .tabItem {
                Label("Timeline", systemImage: "calendar")
            }
            .tag(1)

            NavigationStack {
                ActionsView(viewModel: actionsViewModel)
            }
            .tabItem {
                Label("Actions", systemImage: "checklist")
            }
            .tag(2)
        }
        .tint(.indigo)
    }
}