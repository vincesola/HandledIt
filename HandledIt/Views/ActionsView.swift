import SwiftUI

struct ActionsView: View {
    @ObservedObject var viewModel: ActionsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                filterCard

                if viewModel.filteredActions.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.filteredActions) { action in
                        ActionCard(action: action) {
                            viewModel.toggleCompletion(for: action)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Actions")
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
            Text("No actions for this filter")
                .font(.headline)
            Text("Reviewed events will create follow-up tasks here.")
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

private struct ActionCard: View {
    let action: ActionItem
    let toggleCompletion: () -> Void

    var body: some View {
        Button(action: toggleCompletion) {
            HStack(spacing: 14) {
                Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(action.isCompleted ? .green : action.child.color.color)

                VStack(alignment: .leading, spacing: 6) {
                    Text(action.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .strikethrough(action.isCompleted, color: .secondary)

                    HStack(spacing: 10) {
                        Text(action.child.name)
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(action.child.color.color.opacity(0.16))
                            .foregroundStyle(action.child.color.color)
                            .clipShape(Capsule())

                        if let dueDate = action.dueDate {
                            Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer()
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}