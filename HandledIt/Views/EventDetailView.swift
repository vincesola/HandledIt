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
        .background(Color.handledBackground)
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(event.title)
                .font(.title2.weight(.bold))
                .foregroundColor(.handledTextPrimary)

            Text(event.child.name)
                .font(.caption.weight(.bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(event.child.color.opacity(0.16))
                .foregroundColor(event.child.color)
                .clipShape(Capsule())

            Label(event.date.formatted(date: .complete, time: .omitted), systemImage: "calendar")
                .foregroundColor(.handledTextSecondary)

            if let time = event.time {
                Label(time.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                    .foregroundColor(.handledTextSecondary)
            }

            if let location = event.location, !location.isEmpty {
                Label(location, systemImage: "mappin.and.ellipse")
                    .foregroundColor(.handledTextSecondary)
            }

            Divider()

            Text(event.notes)
                .font(.body)
                .foregroundColor(.handledTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var relatedActionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Related actions")
                .font(.headline)
                .foregroundColor(.handledTextPrimary)

            ForEach(relatedActions) { action in
                HStack(spacing: 12) {
                    Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(action.isCompleted ? .green : .handledTextSecondary)
                    Text(action.title)
                        .foregroundColor(.handledTextPrimary)
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}
