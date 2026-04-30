import SwiftUI

struct EventDetailView: View {
    let event: ParsedEvent
    let relatedActions: [ActionItem]

    private var sourceReference: String {
        String(event.sourceInboxItemId.uuidString.prefix(8)).uppercased()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard
                notesCard
                sourceCard

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
        HandledCard {
            VStack(alignment: .leading, spacing: 14) {
                Text(event.title)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.handledTextPrimary)

                ChildBadge(child: event.child)

                Label(
                    event.date.formatted(date: .complete, time: .omitted),
                    systemImage: "calendar"
                )
                    .foregroundColor(.handledTextSecondary)

                if let time = event.time {
                    Label(
                        time.formatted(date: .omitted, time: .shortened),
                        systemImage: "clock"
                    )
                        .foregroundColor(.handledTextSecondary)
                }

                if let location = event.location, !location.isEmpty {
                    Label(location, systemImage: "mappin.and.ellipse")
                        .foregroundColor(.handledTextSecondary)
                }
            }
        }
    }

    private var notesCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Notes")
                    .font(.headline)
                    .foregroundColor(.handledTextPrimary)

                Text(event.notes)
                    .font(.body)
                    .foregroundColor(.handledTextSecondary)
            }
        }
    }

    private var sourceCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Source reference")
                    .font(.headline)
                    .foregroundColor(.handledTextPrimary)

                Text("Inbox item #\(sourceReference)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.handledPrimary)
            }
        }
    }

    private var relatedActionsCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Related actions")
                    .font(.headline)
                    .foregroundColor(.handledTextPrimary)

                ForEach(relatedActions) { action in
                    HStack(spacing: 12) {
                        Image(
                            systemName: action.isCompleted
                                ? "checkmark.circle.fill"
                                : "circle"
                        )
                            .foregroundColor(action.isCompleted ? .green : action.child.color)
                        Text(action.title)
                            .foregroundColor(.handledTextPrimary)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}
