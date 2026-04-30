import SwiftUI

struct ActionsView: View {
    @EnvironmentObject private var store: HandledItStore
    @State private var selectedChild: ChildProfile? = nil

    private var actionSections: (incomplete: [ActionItem], completed: [ActionItem]) {
        store.actionSections(filteredBy: selectedChild)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
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
            Text("No actions for this filter")
                .font(.headline)
                .foregroundColor(.handledTextPrimary)
            Text("Reviewed events will create follow-up tasks here.")
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
            HStack(spacing: 14) {
                Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(action.isCompleted ? .green : action.child.color)

                VStack(alignment: .leading, spacing: 6) {
                    Text(action.title)
                        .font(.headline)
                        .foregroundColor(.handledTextPrimary)
                        .strikethrough(action.isCompleted, color: .handledTextSecondary)

                    HStack(spacing: 10) {
                        Text(action.child.name)
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(action.child.color.opacity(0.16))
                            .foregroundColor(action.child.color)
                            .clipShape(Capsule())

                        if let dueDate = action.dueDate {
                            Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.handledTextSecondary)
                        }
                    }
                }

                Spacer()
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}
