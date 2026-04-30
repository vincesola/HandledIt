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
}