import SwiftUI

struct HandledCard<Content: View>: View {
    private let content: Content
    private let cornerRadius: CGFloat = 28

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.handledCard)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.handledBorder.opacity(0.7), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

struct ChildBadge: View {
    let child: ChildProfile

    var body: some View {
        HStack(spacing: 9) {
            Circle()
                .fill(child.color.opacity(0.9))
                .frame(width: 7, height: 7)

            Text(child.name)
                .font(.caption.weight(.semibold))
                .foregroundColor(child.color.opacity(0.95))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(child.color.opacity(0.1))
        .overlay(
            Capsule()
                .stroke(child.color.opacity(0.12), lineWidth: 1)
        )
        .clipShape(Capsule())
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.handledPrimary)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.handledTextPrimary)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.handledTextSecondary)
            }
        }
    }
}

struct BrandMarkView: View {
    enum Theme {
        case gradient
        case light
    }

    var size: CGFloat = 56
    var theme: Theme = .gradient

    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: size * 0.32,
                style: .continuous
            )
                .fill(backgroundStyle)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: size * 0.32,
                        style: .continuous
                    )
                    .stroke(borderColor, lineWidth: theme == .light ? 1 : 0)
                )

            ZStack {
                Text("M")
                    .font(
                        .system(
                            size: size * 0.47,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(foregroundColor)

                Image(systemName: "checkmark")
                    .font(.system(size: size * 0.14, weight: .bold))
                    .foregroundColor(foregroundColor.opacity(theme == .light ? 0.92 : 1))
                    .offset(x: size * 0.18, y: size * 0.2)
            }
        }
        .frame(width: size, height: size)
    }

    private var backgroundStyle: some ShapeStyle {
        switch theme {
        case .gradient:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.handledPrimary, Color.gigiPurple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .light:
            return AnyShapeStyle(Color.white.opacity(0.12))
        }
    }

    private var foregroundColor: Color {
        switch theme {
        case .gradient, .light:
            return .white
        }
    }

    private var borderColor: Color {
        switch theme {
        case .gradient:
            return .clear
        case .light:
            return .white.opacity(0.16)
        }
    }
}