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

    struct ReviewSeed {
        let title: String
        let date: Date
        let time: Date?
        let location: String
        let child: ChildProfile
        let notes: String
        let actionTitles: [String]
    }

    var sortedInboxItems: [InboxItem] {
        inboxItems.sorted { $0.dateAdded > $1.dateAdded }
    }

    var sortedEvents: [ParsedEvent] {
        events.sorted { $0.date < $1.date }
    }

    var sortedActionItems: [ActionItem] {
        actionItems
    }

    func reviewSeed(for item: InboxItem) -> ReviewSeed {
        let year = Calendar.current.component(.year, from: Date())

        switch item.title {
        case "Field Day screenshot":
            let date = Calendar.current.date(
                from: DateComponents(year: year, month: 5, day: 10)
            ) ?? Date()
            let time = Calendar.current.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: date
            )

            return ReviewSeed(
                title: "Field Day",
                date: date,
                time: time,
                location: "Lincoln Elementary",
                child: item.child ?? .gigi,
                notes: "Suggested from the screenshot.\nDouble-check pickup logistics before saving.",
                actionTitles: [
                    "Bring water bottle",
                    "Wear sunscreen"
                ]
            )

        case "PTA email":
            let date = Calendar.current.date(
                from: DateComponents(year: year, month: 5, day: 14)
            ) ?? Date()
            let time = Calendar.current.date(
                bySettingHour: 18,
                minute: 30,
                second: 0,
                of: date
            )

            return ReviewSeed(
                title: "PTA Meeting",
                date: date,
                time: time,
                location: "Media Center",
                child: item.child ?? .both,
                notes: "Volunteer sign-up was mentioned in the message.",
                actionTitles: ["Reply to volunteer form"]
            )

        case "Pizza day reminder":
            let date = Calendar.current.date(
                from: DateComponents(year: year, month: 5, day: 17)
            ) ?? Date()

            return ReviewSeed(
                title: "Pizza Day",
                date: date,
                time: nil,
                location: "",
                child: item.child ?? .mila,
                notes: "Pepperoni preference was called out in the reminder.",
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

    func addReviewedEvent(
        from item: InboxItem,
        title: String,
        date: Date,
        time: Date?,
        location: String?,
        notes: String,
        child: ChildProfile,
        actionTitles: [String]
    ) {
        let normalizedLocation = location?.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let normalizedActions = actionTitles
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let event = ParsedEvent(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            date: date,
            time: time,
            location: normalizedLocation?.isEmpty == false ? normalizedLocation : nil,
            child: child,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceInboxItemId: item.id
        )

        events.append(event)
        events.sort { $0.date < $1.date }

        let newActions = normalizedActions.map {
            ActionItem(
                title: $0,
                child: child,
                dueDate: date
            )
        }

        actionItems.insert(contentsOf: newActions, at: 0)
        inboxItems.removeAll { $0.id == item.id }
    }

    func ignoreInboxItem(_ item: InboxItem) {
        inboxItems.removeAll { $0.id == item.id }
    }

    func toggleActionCompletion(_ action: ActionItem) {
        guard let index = actionItems.firstIndex(where: { $0.id == action.id }) else {
            return
        }

        actionItems[index].isCompleted.toggle()
    }

    func relatedActionItems(for event: ParsedEvent) -> [ActionItem] {
        actionItems
            .filter {
                $0.child == event.child
                    && ($0.dueDate.map {
                        Calendar.current.isDate($0, inSameDayAs: event.date)
                    } ?? false)
            }
            .sorted {
                ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)
            }
    }

    func groupedEvents(
        filteredBy child: ChildProfile? = nil
    ) -> [(date: Date, events: [ParsedEvent])] {
        let filtered = events
            .filter { child == nil || $0.child == child }
            .sorted { $0.date < $1.date }

        let grouped = Dictionary(grouping: filtered) {
            Calendar.current.startOfDay(for: $0.date)
        }

        return grouped
            .keys
            .sorted()
            .map { date in
                let groupedEvents = grouped[date, default: []].sorted {
                    ($0.time ?? .distantFuture) < ($1.time ?? .distantFuture)
                }

                return (date: date, events: groupedEvents)
            }
    }

    func filteredActions(filteredBy child: ChildProfile? = nil) -> [ActionItem] {
        actionItems
            .filter { child == nil || $0.child == child }
            .sorted { lhs, rhs in
                if lhs.isCompleted != rhs.isCompleted {
                    return !lhs.isCompleted
                }

                return (lhs.dueDate ?? .distantFuture)
                    < (rhs.dueDate ?? .distantFuture)
            }
    }

    func actionSections(
        filteredBy child: ChildProfile? = nil
    ) -> (incomplete: [ActionItem], completed: [ActionItem]) {
        let actions = filteredActions(filteredBy: child)

        return (
            incomplete: actions.filter { !$0.isCompleted },
            completed: actions.filter { $0.isCompleted }
        )
    }

    private static func makeMockState(
        calendar: Calendar
    ) -> (
        inboxItems: [InboxItem],
        events: [ParsedEvent],
        actionItems: [ActionItem]
    ) {
        let currentYear = calendar.component(.year, from: Date())
        let now = Date()

        let fieldDayDate = calendar.date(
            from: DateComponents(year: currentYear, month: 5, day: 10)
        ) ?? now
        let fieldDayTime = calendar.date(
            bySettingHour: 9,
            minute: 0,
            second: 0,
            of: fieldDayDate
        )
        let ptaDate = calendar.date(
            from: DateComponents(year: currentYear, month: 5, day: 14)
        ) ?? now
        let pizzaDate = calendar.date(
            from: DateComponents(year: currentYear, month: 5, day: 17)
        ) ?? now

        let fieldDayInbox = InboxItem(
            title: "Field Day screenshot",
            content: "Field Day is on May 10 at 9:00 AM. Bring a water bottle and wear sunscreen.",
            type: .image,
            dateAdded: now.addingTimeInterval(-1_800),
            child: .gigi
        )

        let ptaInbox = InboxItem(
            title: "PTA email",
            content: "PTA meeting this Wednesday at 6:30 PM in the media center. Volunteer sign-up is due Friday.",
            type: .email,
            dateAdded: now.addingTimeInterval(-7_200),
            child: .both
        )

        let pizzaInbox = InboxItem(
            title: "Pizza day reminder",
            content: "Pizza order due by next Friday. Mila wants pepperoni.",
            type: .text,
            dateAdded: now.addingTimeInterval(-14_400),
            child: .mila
        )

        let fieldDayEvent = ParsedEvent(
            title: "Field Day",
            date: fieldDayDate,
            time: fieldDayTime,
            location: "Lincoln Elementary",
            child: .gigi,
            notes: "Suggested from a screenshot.\nConfirm supplies before leaving.",
            sourceInboxItemId: fieldDayInbox.id
        )

        let actions = [
            ActionItem(
                title: "Bring water bottle",
                child: .gigi,
                dueDate: fieldDayDate
            ),
            ActionItem(
                title: "Wear sunscreen",
                child: .gigi,
                dueDate: fieldDayDate
            ),
            ActionItem(
                title: "Reply to PTA volunteer form",
                child: .both,
                dueDate: ptaDate
            ),
            ActionItem(
                title: "Submit pizza order",
                isCompleted: true,
                child: .mila,
                dueDate: pizzaDate
            )
        ]

        return (
            inboxItems: [fieldDayInbox, ptaInbox, pizzaInbox],
            events: [fieldDayEvent],
            actionItems: actions
        )
    }
}
