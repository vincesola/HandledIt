import Combine
import Foundation

final class ActionsViewModel: ObservableObject {
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

    var filteredActions: [ActionItem] {
        store.actionItems
            .filter { action in
                guard let selectedChild else {
                    return true
                }

                return action.child == selectedChild
            }
            .sorted { lhs, rhs in
                if lhs.isCompleted != rhs.isCompleted {
                    return !lhs.isCompleted
                }

                return (lhs.dueDate ?? .distantFuture) < (rhs.dueDate ?? .distantFuture)
            }
    }

    func toggleCompletion(for action: ActionItem) {
        store.toggleAction(id: action.id)
    }
}