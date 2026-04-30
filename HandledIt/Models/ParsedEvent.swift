import Foundation

struct ParsedEvent: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let date: Date
    let time: Date?
    let location: String?
    let child: ChildProfile
    let notes: String
    let sourceInboxItemId: UUID

    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        time: Date? = nil,
        location: String? = nil,
        child: ChildProfile,
        notes: String = "",
        sourceInboxItemId: UUID
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.time = time
        self.location = location
        self.child = child
        self.notes = notes
        self.sourceInboxItemId = sourceInboxItemId
    }
}
