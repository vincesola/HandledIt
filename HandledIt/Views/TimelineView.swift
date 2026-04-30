import SwiftUI

struct TimelineView: View {
    @ObservedObject var viewModel: TimelineViewModel
    let openActionsTab: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                filterCard

                if viewModel.filteredEvents.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.filteredEvents) { event in
                        NavigationLink {
                            EventDetailView(event: event, relatedActions: viewModel.relatedActionItems(for: event))
                        } label: {
                            TimelineCard(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Timeline")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Actions", action: openActionsTab)
            }
        }
    }

    private var filterCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Child filter")
                .font(.headline)
            Picker("Child filter", selection: $viewModel.selectedChild) {
                Text("All").tag(Optional<ChildProfile>.none)
                ForEach(viewModel.childProfiles) { child in
                    Text(child.name).tag(Optional(child))
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No events for this filter")
                .font(.headline)
            Text("Save a reviewed inbox item to populate the timeline.")
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

private struct TimelineCard: View {
    let event: ParsedEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(event.date.formatted(date: .complete, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if let time = event.time {
                        Text(time.formatted(date: .omitted, time: .shortened))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer(minLength: 12)

                Text(event.child.name)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(event.child.color.color.opacity(0.16))
                    .foregroundStyle(event.child.color.color)
                    .clipShape(Capsule())
            }

            if let location = event.location, !location.isEmpty {
                Label(location, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text(event.notes)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}