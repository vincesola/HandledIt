import SwiftUI

extension Color {
    static let handledPrimary = Color(red: 79 / 255, green: 70 / 255, blue: 229 / 255)
    static let gigiPurple = Color(red: 139 / 255, green: 92 / 255, blue: 246 / 255)
    static let milaTeal = Color(red: 20 / 255, green: 184 / 255, blue: 166 / 255)
    static let handledBackground = Color(red: 248 / 255, green: 250 / 255, blue: 252 / 255)
    static let handledCard = Color(red: 252 / 255, green: 252 / 255, blue: 253 / 255)
    static let handledTextPrimary = Color(red: 15 / 255, green: 23 / 255, blue: 42 / 255)
    static let handledTextSecondary = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let handledBorder = Color(red: 226 / 255, green: 232 / 255, blue: 240 / 255)

    static func handledColor(for colorName: String) -> Color {
        switch colorName {
        case "GigiPurple":
            return .gigiPurple
        case "MilaTeal":
            return .milaTeal
        case "BothIndigo":
            return .handledPrimary
        default:
            return .handledPrimary
        }
    }
}
