import SwiftUI

enum ChildColor: String, CaseIterable, Codable {
    case gigiPurple
    case milaTeal
    case bothIndigo

    var color: Color {
        switch self {
        case .gigiPurple:
            return .purple
        case .milaTeal:
            return .teal
        case .bothIndigo:
            return .indigo
        }
    }
}

struct ChildProfile: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let color: ChildColor

    static let gigi = ChildProfile(
        id: UUID(uuidString: "C6680F6B-3E30-4F7A-AE32-1D9B53967F10")!,
        name: "Gigi",
        color: .gigiPurple
    )

    static let mila = ChildProfile(
        id: UUID(uuidString: "DC97F509-E62D-4E95-A7A9-B20378A38C76")!,
        name: "Mila",
        color: .milaTeal
    )

    static let both = ChildProfile(
        id: UUID(uuidString: "7A6D0E66-B5E4-4C18-9B2A-B98A12B69B86")!,
        name: "Both",
        color: .bothIndigo
    )

    static let allProfiles: [ChildProfile] = [.gigi, .mila, .both]
}