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
                            ReviewItemView(item: item, seed: store.reviewSeed(for: item))
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
        HandledCard {
            HStack(alignment: .top, spacing: 16) {
                BrandMarkView()

                VStack(alignment: .leading, spacing: 6) {
                    Text("HandledIt")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.handledTextPrimary)

                    Text("Life, handled.")
                        .font(.headline)
                        .foregroundColor(.handledPrimary)

                    Text("Review what matters before it becomes an event or task.")
                        .font(.subheadline)
                        .foregroundColor(.handledTextSecondary)
                }
            }
        }
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

                    Text(item.dateAdded.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.handledTextSecondary)
                }

                HStack {
                    Spacer()

                    Label("Review", systemImage: "arrow.right.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.handledPrimary)
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
