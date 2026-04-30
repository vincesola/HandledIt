import Combine
import Foundation

final class InboxViewModel: ObservableObject {
    struct ReviewSeed {
        let title: String
        let date: Date
        let time: Date?
        let location: String
        let child: ChildProfile
        let notes: String
        let actionTitles: [String]
    }

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

    var inboxItems: [InboxItem] {
        store.inboxItems.sorted { $0.dateAdded > $1.dateAdded }
    }

    var childProfiles: [ChildProfile] {
        store.childProfiles
    }

    func reviewSeed(for item: InboxItem) -> ReviewSeed {
        let year = Calendar.current.component(.year, from: Date())

        // Phase 2 and Phase 3 plug OCR and smarter extraction into this seed builder.
        switch item.title {
        case "Field Day screenshot":
            let date = Calendar.current.date(from: DateComponents(year: year, month: 5, day: 10)) ?? Date()
            let time = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: date)
            return ReviewSeed(
                title: "Field Day",
                date: date,
                time: time,
                location: "Lincoln Elementary",
                child: item.child ?? .gigi,
                notes: "Suggested from the screenshot. Double-check pickup logistics before saving.",
                actionTitles: ["Bring water bottle", "Wear sunscreen"]
            )
        case "PTA email":
            let date = Calendar.current.date(from: DateComponents(year: year, month: 5, day: 14)) ?? Date()
            let time = Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: date)
            return ReviewSeed(
                title: "PTA Meeting",
                date: date,
                time: time,
                location: "Media Center",
                child: item.child ?? .both,
                notes: "Volunteer sign-up mentioned in the message.",
                actionTitles: ["Reply to volunteer form"]
            )
        case "Pizza day reminder":
            let date = Calendar.current.date(from: DateComponents(year: year, month: 5, day: 17)) ?? Date()
            return ReviewSeed(
                title: "Pizza Day",
                date: date,
                time: nil,
                location: "",
                child: item.child ?? .mila,
                notes: "Pepperoni preference called out in the reminder.",
                actionTitles: ["Submit pizza order"]
            )
        default:
            return ReviewSeed(
                title: item.title,
                date: Date(),
                time: nil,
                location: "",
                child: item.child ?? .both,
                notes: item.content,
                actionTitles: []
            )
        }
    }

    func saveReviewedItem(
        sourceItem: InboxItem,
        title: String,
        date: Date,
        time: Date?,
        location: String,
        notes: String,
        child: ChildProfile,
        actionTitles: [String]
    ) {
        store.addReviewedEvent(
            from: sourceItem,
            title: title,
            date: date,
            time: time,
            location: location,
            notes: notes,
            child: child,
            actionTitles: actionTitles
        )
    }
}