import SwiftUI

struct ActionsView: View {
    @EnvironmentObject private var store: HandledItStore
    @State private var selectedChild: ChildProfile? = nil

    private var actionSections: (incomplete: [ActionItem], completed: [ActionItem]) {
        store.actionSections(filteredBy: selectedChild)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                filterSection

                if actionSections.incomplete.isEmpty && actionSections.completed.isEmpty {
                    emptyState
                } else {
                    if !actionSections.incomplete.isEmpty {
                        SectionHeader(title: "Open tasks")
                        ForEach(actionSections.incomplete) { action in
                            ActionCard(action: action) {
                                store.toggleActionCompletion(action)
                            }
                        }
                    }

                    if !actionSections.completed.isEmpty {
                        SectionHeader(title: "Completed")
                        ForEach(actionSections.completed) { action in
                            ActionCard(action: action) {
                                store.toggleActionCompletion(action)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color.handledBackground)
        .navigationTitle("Actions")
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
            title: "Nothing to handle right now.",
            message: "When you save reviewed items, follow-up actions will appear here.",
            systemImage: "checkmark.circle"
        )
    }
}

private struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.handledTextPrimary)
            .padding(.vertical, 8)
    }
}

private struct ActionCard: View {
    let action: ActionItem
    let toggleCompletion: () -> Void

    var body: some View {
        Button(action: toggleCompletion) {
            HandledCard {
                HStack(spacing: 14) {
                    Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(action.isCompleted ? .green : action.child.color)

                    Circle()
                        .fill(action.child.color)
                        .frame(width: 10, height: 10)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(action.title)
                            .font(.headline)
                            .foregroundColor(.handledTextPrimary)
                            .strikethrough(action.isCompleted, color: .handledTextSecondary)

                        HStack(spacing: 10) {
                            ChildBadge(child: action.child)

                            if let dueDate = action.dueDate {
                                Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.handledTextSecondary)
                            }
                        }
                    }

                    Spacer()
                }
                .opacity(action.isCompleted ? 0.65 : 1)
            }
        }
        .buttonStyle(.plain)
    }
}
