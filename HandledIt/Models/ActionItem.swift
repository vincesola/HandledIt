import Foundation

struct ActionItem: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
    let child: ChildProfile
    let dueDate: Date?
}