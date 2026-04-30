import SwiftUI

struct InboxView: View {
    @ObservedObject var viewModel: InboxViewModel
    let onReviewSaved: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Manual items waiting for review. Suggestions stay editable until you confirm them.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if viewModel.inboxItems.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.inboxItems) { item in
                        NavigationLink {
                            ReviewItemView(item: item, viewModel: viewModel, onSaveComplete: onReviewSaved)
                        } label: {
                            InboxCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Inbox")
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Inbox cleared")
                .font(.headline)
            Text("New screenshots, emails, and notes will appear here in a future input phase.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
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
                        .foregroundStyle(.primary)
                    Text(item.content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 12)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }

            HStack(spacing: 10) {
                Label(item.type.rawValue.capitalized, systemImage: iconName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                if let child = item.child {
                    Text(child.name)
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(child.color.color.opacity(0.16))
                        .foregroundStyle(child.color.color)
                        .clipShape(Capsule())
                }

                Spacer()

                Text(item.dateAdded.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
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