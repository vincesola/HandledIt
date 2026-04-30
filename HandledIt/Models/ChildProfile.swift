import SwiftUI

struct ChildProfile: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let colorName: String

    var color: Color {
        Color.handledColor(for: colorName)
    }

    init(
        id: UUID = UUID(),
        name: String,
        colorName: String
    ) {
        self.id = id
        self.name = name
        self.colorName = colorName
    }

    static let gigi = ChildProfile(name: "Gigi", colorName: "GigiPurple")
    static let mila = ChildProfile(name: "Mila", colorName: "MilaTeal")
    static let both = ChildProfile(name: "Both", colorName: "BothIndigo")

    static let allProfiles: [ChildProfile] = [.gigi, .mila, .both]
}
