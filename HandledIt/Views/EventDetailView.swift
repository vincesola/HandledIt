import SwiftUI

struct EventDetailView: View {
    let event: ParsedEvent
    let relatedActions: [ActionItem]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                summaryCard

                if !relatedActions.isEmpty {
                    relatedActionsCard
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(event.title)
                .font(.title2.weight(.bold))

            Text(event.child.name)
                .font(.caption.weight(.bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(event.child.color.color.opacity(0.16))
                .foregroundStyle(event.child.color.color)
                .clipShape(Capsule())

            Label(event.date.formatted(date: .complete, time: .omitted), systemImage: "calendar")

            if let time = event.time {
                Label(time.formatted(date: .omitted, time: .shortened), systemImage: "clock")
            }

            if let location = event.location, !location.isEmpty {
                Label(location, systemImage: "mappin.and.ellipse")
            }

            Divider()

            Text(event.notes)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var relatedActionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Related actions")
                .font(.headline)

            ForEach(relatedActions) { action in
                HStack(spacing: 12) {
                    Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(action.isCompleted ? .green : .secondary)
                    Text(action.title)
                        .foregroundStyle(.primary)
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}