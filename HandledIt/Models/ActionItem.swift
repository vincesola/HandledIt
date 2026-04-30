import Foundation

struct ActionItem: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
    let child: ChildProfile
    let dueDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        child: ChildProfile,
        dueDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.child = child
        self.dueDate = dueDate
    }
}
