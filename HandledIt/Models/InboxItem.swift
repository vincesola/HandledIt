import Foundation

enum InboxItemType: String, CaseIterable, Codable {
    case text
    case image
    case email
}

struct InboxItem: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let content: String
    let type: InboxItemType
    let dateAdded: Date
    let child: ChildProfile?

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        type: InboxItemType,
        dateAdded: Date = Date(),
        child: ChildProfile? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.dateAdded = dateAdded
        self.child = child
    }
}
