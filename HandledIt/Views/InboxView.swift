import SwiftUI

struct InboxView: View {
    @EnvironmentObject private var store: HandledItStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Manual items waiting for review. Suggestions stay editable until you confirm them.")
                    .font(.subheadline)
                    .foregroundColor(.handledTextSecondary)

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
        .navigationTitle("Inbox")
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Inbox cleared")
                .font(.headline)
                .foregroundColor(.handledTextPrimary)
            Text("New screenshots, emails, and notes will appear here in a future input phase.")
                .font(.subheadline)
                .foregroundColor(.handledTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}

private struct InboxCard: View {
    let item: InboxItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.handledTextPrimary)
                    Text(item.content)
                        .font(.subheadline)
                        .foregroundColor(.handledTextSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 12)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.handledTextSecondary)
            }

            HStack(spacing: 10) {
                Label(item.type.rawValue.capitalized, systemImage: iconName)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.handledTextSecondary)

                if let child = item.child {
                    Text(child.name)
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(child.color.opacity(0.16))
                        .foregroundColor(child.color)
                        .clipShape(Capsule())
                }

                Spacer()

                Text(item.dateAdded.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.handledTextSecondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
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
