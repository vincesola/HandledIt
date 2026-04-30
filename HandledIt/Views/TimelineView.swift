import SwiftUI

struct TimelineView: View {
    @EnvironmentObject private var store: HandledItStore
    @State private var selectedChild: ChildProfile? = nil

    private var groupedEvents: [(date: Date, events: [ParsedEvent])] {
        store.groupedEvents(filteredBy: selectedChild)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
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
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No events for this filter")
                .font(.headline)
                .foregroundColor(.handledTextPrimary)
            Text("Save a reviewed inbox item to populate the timeline.")
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

private struct TimelineCard: View {
    let event: ParsedEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(.handledTextPrimary)

                    if let time = event.time {
                        Text(time.formatted(date: .omitted, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.handledTextSecondary)
                    }

                    Text(event.location ?? "")
                        .font(.subheadline)
                        .foregroundColor(.handledTextSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 12)

                Text(event.child.name)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(event.child.color.opacity(0.16))
                    .foregroundColor(event.child.color)
                    .clipShape(Capsule())
            }

            HStack {
                Text(event.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.handledTextSecondary)
                Spacer()
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}
