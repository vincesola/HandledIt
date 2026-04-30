import Combine
import Foundation

final class HandledItStore: ObservableObject {
    @Published private(set) var childProfiles: [ChildProfile]
    @Published private(set) var inboxItems: [InboxItem]
    @Published private(set) var events: [ParsedEvent]
    @Published private(set) var actionItems: [ActionItem]

    init(calendar: Calendar = .current) {
        self.childProfiles = ChildProfile.allProfiles

        let seed = Self.makeMockState(calendar: calendar)
        self.inboxItems = seed.inboxItems
        self.events = seed.events
        self.actionItems = seed.actionItems
    }

    func saveReviewedItem(
        sourceItem: InboxItem,
        title: String,
        date: Date,
        time: Date?,
        location: String?,
        notes: String,
        child: ChildProfile,
        actionTitles: [String]
    ) {
        let normalizedLocation = location?.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedActions = actionTitles
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let event = ParsedEvent(
            id: UUID(),
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            date: date,
            time: time,
            location: normalizedLocation?.isEmpty == false ? normalizedLocation : nil,
            child: child,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceInboxItemId: sourceItem.id
        )

        events.append(event)
        events.sort { $0.date < $1.date }

        let newActions = normalizedActions.map {
            ActionItem(
                id: UUID(),
                title: $0,
                isCompleted: false,
                child: child,
                dueDate: date
            )
        }

        actionItems.insert(contentsOf: newActions, at: 0)
        inboxItems.removeAll { $0.id == sourceItem.id }

        // Phase 4 plugs EventKit sync in here once local persistence is stable.
    }

    func toggleAction(id: ActionItem.ID) {
        guard let index = actionItems.firstIndex(where: { $0.id == id }) else {
            return
        }

        actionItems[index].isCompleted.toggle()
    }

    func relatedActionItems(for event: ParsedEvent) -> [ActionItem] {
        actionItems
            .filter {
                $0.child == event.child &&
                ($0.dueDate.map { Calendar.current.isDate($0, inSameDayAs: event.date) } ?? false)
            }
            .sorted {
                ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)
            }
    }

    private static func makeMockState(calendar: Calendar) -> (inboxItems: [InboxItem], events: [ParsedEvent], actionItems: [ActionItem]) {
        let currentYear = calendar.component(.year, from: Date())
        let now = Date()

        let fieldDayDate = calendar.date(from: DateComponents(year: currentYear, month: 5, day: 10)) ?? now
        let fieldDayTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: fieldDayDate)
        let ptaDate = calendar.date(from: DateComponents(year: currentYear, month: 5, day: 14)) ?? now
        let pizzaDate = calendar.date(from: DateComponents(year: currentYear, month: 5, day: 17)) ?? now

        let fieldDayInbox = InboxItem(
            id: UUID(),
            title: "Field Day screenshot",
            content: "Field Day is on May 10 at 9:00 AM. Bring a water bottle and wear sunscreen.",
            type: .image,
            dateAdded: now.addingTimeInterval(-1_800),
            child: .gigi
        )

        let ptaInbox = InboxItem(
            id: UUID(),
            title: "PTA email",
            content: "PTA meeting this Wednesday at 6:30 PM in the media center. Volunteer sign-up is due Friday.",
            type: .email,
            dateAdded: now.addingTimeInterval(-7_200),
            child: .both
        )

        let pizzaInbox = InboxItem(
            id: UUID(),
            title: "Pizza day reminder",
            content: "Pizza order due by next Friday. Mila wants pepperoni.",
            type: .text,
            dateAdded: now.addingTimeInterval(-14_400),
            child: .mila
        )

        let fieldDayEvent = ParsedEvent(
            id: UUID(),
            title: "Field Day",
            date: fieldDayDate,
            time: fieldDayTime,
            location: "Lincoln Elementary",
            child: .gigi,
            notes: "Suggested from a screenshot. Confirm supplies before leaving.",
            sourceInboxItemId: fieldDayInbox.id
        )

        let actions = [
            ActionItem(id: UUID(), title: "Bring water bottle", isCompleted: false, child: .gigi, dueDate: fieldDayDate),
            ActionItem(id: UUID(), title: "Wear sunscreen", isCompleted: false, child: .gigi, dueDate: fieldDayDate),
            ActionItem(id: UUID(), title: "Reply to PTA volunteer form", isCompleted: false, child: .both, dueDate: ptaDate),
            ActionItem(id: UUID(), title: "Submit pizza order", isCompleted: true, child: .mila, dueDate: pizzaDate)
        ]

        return (
            inboxItems: [fieldDayInbox, ptaInbox, pizzaInbox],
            events: [fieldDayEvent],
            actionItems: actions
        )
    }
}