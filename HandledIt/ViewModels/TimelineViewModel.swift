import Combine
import Foundation

final class TimelineViewModel: ObservableObject {
    @Published var selectedChild: ChildProfile?

    private let store: HandledItStore
    private var cancellables = Set<AnyCancellable>()

    init(store: HandledItStore) {
        self.store = store

        store.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    var childProfiles: [ChildProfile] {
        store.childProfiles
    }

    var filteredEvents: [ParsedEvent] {
        store.events
            .filter { event in
                guard let selectedChild else {
                    return true
                }

                return event.child == selectedChild
            }
            .sorted { $0.date < $1.date }
    }

    func relatedActionItems(for event: ParsedEvent) -> [ActionItem] {
        store.relatedActionItems(for: event)
    }
}