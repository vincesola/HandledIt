import SwiftUI

struct TimelineView: View {
    @EnvironmentObject private var store: HandledItStore
    @State private var selectedChild: ChildProfile? = nil

    private var groupedEvents: [(date: Date, events: [ParsedEvent])] {
        store.groupedEvents(filteredBy: selectedChild)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                filterSection

                if groupedEvents.isEmpty {
                    emptyState
                } else {
                    ForEach(groupedEvents, id: \.date) { group in
                        VStack(alignment: .leading, spacing: 14) {
                            Text(group.date.formatted(date: .long, time: .omitted))
                                .font(.headline)
                                .foregroundColor(.handledTextPrimary)

                            ForEach(group.events) { event in
                                NavigationLink {
                                    EventDetailView(event: event, relatedActions: store.relatedActionItems(for: event))
                                } label: {
                                    TimelineCard(event: event)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color.handledBackground)
        .navigationTitle("Timeline")
    }

    private var filterSection: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Child filter")
                    .font(.headline)
                    .foregroundColor(.handledTextPrimary)

                Picker("Child filter", selection: $selectedChild) {
                    Text("All").tag(Optional<ChildProfile>.none)
                    ForEach(store.childProfiles) { child in
                        Text(child.name).tag(Optional(child))
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private var emptyState: some View {
        EmptyStateView(
            title: "No events yet",
            message: "Review inbox items to build your timeline.",
            systemImage: "calendar.badge.exclamationmark"
        )
    }
}

private struct TimelineCard: View {
    let event: ParsedEvent

    var body: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(event.child.color)
                        .frame(width: 10, height: 10)
                        .padding(.top, 7)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(event.title)
                            .font(.headline)
                            .foregroundColor(.handledTextPrimary)

                        HStack(spacing: 8) {
                            ChildBadge(child: event.child)

                            if let time = event.time {
                                Text(time.formatted(date: .omitted, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.handledTextSecondary)
                            }
                        }

                        if let location = event.location, !location.isEmpty {
                            Label(location, systemImage: "mappin.and.ellipse")
                                .font(.subheadline)
                                .foregroundColor(.handledTextSecondary)
                        }
                    }

                    Spacer()
                }
            }
        }
    }
}
