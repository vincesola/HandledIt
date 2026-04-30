import SwiftUI

struct InboxView: View {
    @EnvironmentObject private var store: HandledItStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection

                if store.sortedInboxItems.isEmpty {
                    emptyState
                } else {
                    ForEach(store.sortedInboxItems) { item in
                        NavigationLink {
                            ReviewItemView(
                                item: item,
                                seed: store.reviewSeed(for: item)
                            )
                        } label: {
                            InboxCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(Color.handledBackground)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                BrandMarkView(size: 60)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Inbox")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.handledPrimary)
                        .textCase(.uppercase)

                    Text("HandledIt")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.handledTextPrimary)

                    Text("Life, handled.")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.handledTextPrimary)

                    Text("Review what matters before it becomes an event or task.")
                        .font(.subheadline)
                        .foregroundColor(.handledTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            HStack(spacing: 12) {
                headerMetric(
                    title: "Ready to review",
                    value: "\(store.sortedInboxItems.count)"
                )

                headerMetric(
                    title: "Status",
                    value: store.sortedInboxItems.isEmpty ? "Clear" : "Active"
                )
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.handledPrimary.opacity(0.08),
                    Color.handledCard
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.handledBorder.opacity(0.9), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.black.opacity(0.035), radius: 14, x: 0, y: 8)
    }

    private func headerMetric(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.handledTextSecondary)

            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundColor(.handledTextPrimary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.handledCard.opacity(0.85))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.handledBorder.opacity(0.75), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var emptyState: some View {
        EmptyStateView(
            title: "Inbox cleared",
            message: "New screenshots, emails, and notes will appear here in a future input phase.",
            systemImage: "tray"
        )
    }
}

private struct InboxCard: View {
    let item: InboxItem

    var body: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.handledPrimary.opacity(0.1))
                            .frame(width: 42, height: 42)

                        Image(systemName: iconName)
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.handledPrimary)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.handledTextPrimary)

                        Text(item.content)
                            .font(.subheadline)
                            .foregroundColor(.handledTextSecondary)
                            .lineLimit(2)
                    }

                    Spacer(minLength: 12)

                    if let child = item.child {
                        RoundedRectangle(cornerRadius: 999, style: .continuous)
                            .fill(child.color)
                            .frame(width: 6, height: 42)
                    }
                }

                HStack(spacing: 10) {
                    Text(item.type.rawValue.capitalized)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.handledTextSecondary)

                    if let child = item.child {
                        ChildBadge(child: child)
                    }

                    Spacer()

                    Text(
                        item.dateAdded.formatted(
                            date: .abbreviated,
                            time: .shortened
                        )
                    )
                        .font(.caption)
                        .foregroundColor(.handledTextSecondary)
                }

                HStack {
                    Spacer()

                    HStack(spacing: 8) {
                        Text("Review")
                            .font(.subheadline.weight(.semibold))

                        Image(systemName: "arrow.right")
                            .font(.caption.weight(.bold))
                    }
                    .foregroundColor(.handledPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.handledPrimary.opacity(0.1))
                    .overlay(
                        Capsule()
                            .stroke(Color.handledPrimary.opacity(0.18), lineWidth: 1)
                    )
                    .clipShape(Capsule())
                }
            }
        }
    }

    private var iconName: String {
        switch item.type {
        case .text:
            return "text.bubble"
        case .image:
            return "photo"
        case .email:
            return "envelope"
        }
    }
}
