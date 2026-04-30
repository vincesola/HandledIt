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
}