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
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
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
    var size: CGFloat = 56

    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: size * 0.32,
                style: .continuous
            )
                .fill(
                    LinearGradient(
                        colors: [Color.handledPrimary, Color.gigiPurple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("H")
                .font(
                    .system(
                        size: size * 0.5,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundColor(.white)
        }
        .frame(width: size, height: size)
    }
}