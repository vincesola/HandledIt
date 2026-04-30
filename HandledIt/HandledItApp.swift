import SwiftUI

@main
struct HandledItApp: App {
    @StateObject private var store: HandledItStore
    @StateObject private var inboxViewModel: InboxViewModel
    @StateObject private var timelineViewModel: TimelineViewModel
    @StateObject private var actionsViewModel: ActionsViewModel

    init() {
        let sharedStore = HandledItStore()
        _store = StateObject(wrappedValue: sharedStore)
        _inboxViewModel = StateObject(wrappedValue: InboxViewModel(store: sharedStore))
        _timelineViewModel = StateObject(wrappedValue: TimelineViewModel(store: sharedStore))
        _actionsViewModel = StateObject(wrappedValue: ActionsViewModel(store: sharedStore))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                inboxViewModel: inboxViewModel,
                timelineViewModel: timelineViewModel,
                actionsViewModel: actionsViewModel
            )
        }
    }
}