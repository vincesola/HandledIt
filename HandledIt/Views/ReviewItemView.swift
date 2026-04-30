import SwiftUI

struct ReviewItemView: View {
    let item: InboxItem
    @ObservedObject var viewModel: InboxViewModel
    let onSaveComplete: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var eventDate: Date
    @State private var includeTime: Bool
    @State private var eventTime: Date
    @State private var location: String
    @State private var selectedChild: ChildProfile
    @State private var notes: String
    @State private var actionTitles: [String]

    init(item: InboxItem, viewModel: InboxViewModel, onSaveComplete: @escaping () -> Void) {
        self.item = item
        self.viewModel = viewModel
        self.onSaveComplete = onSaveComplete

        let seed = viewModel.reviewSeed(for: item)
        _title = State(initialValue: seed.title)
        _eventDate = State(initialValue: seed.date)
        _includeTime = State(initialValue: seed.time != nil)
        _eventTime = State(initialValue: seed.time ?? seed.date)
        _location = State(initialValue: seed.location)
        _selectedChild = State(initialValue: seed.child)
        _notes = State(initialValue: seed.notes)
        _actionTitles = State(initialValue: seed.actionTitles)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                sourceCard
                detailsCard
                actionsCard
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button(action: save) {
                Text("Save to Timeline")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 14)
            .background(.thinMaterial)
        }
    }

    private var sourceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Source")
                .font(.headline)
            Text(item.title)
                .font(.title3.weight(.semibold))
            Text(item.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Suggested details")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                TextField("Event title", text: $title)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Date")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                DatePicker("", selection: $eventDate, displayedComponents: .date)
                    .labelsHidden()
            }

            Toggle("Include time", isOn: $includeTime)

            if includeTime {
                DatePicker("Time", selection: $eventTime, displayedComponents: .hourAndMinute)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Location")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                TextField("Optional location", text: $location)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Child")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Picker("Child", selection: $selectedChild) {
                    ForEach(viewModel.childProfiles) { child in
                        Text(child.name).tag(child)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Notes")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                TextEditor(text: $notes)
                    .frame(minHeight: 110)
                    .padding(8)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var actionsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Action items")
                    .font(.headline)
                Spacer()
                Button("Add") {
                    actionTitles.append("")
                }
            }

            if actionTitles.isEmpty {
                Text("No actions suggested yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(actionTitles.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Image(systemName: "circle")
                            .foregroundStyle(.secondary)

                        TextField("Action item", text: binding(for: index))
                            .textFieldStyle(.roundedBorder)

                        Button {
                            actionTitles.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private func binding(for index: Int) -> Binding<String> {
        Binding(
            get: { actionTitles[index] },
            set: { actionTitles[index] = $0 }
        )
    }

    private func save() {
        viewModel.saveReviewedItem(
            sourceItem: item,
            title: title,
            date: eventDate,
            time: includeTime ? eventTime : nil,
            location: location,
            notes: notes,
            child: selectedChild,
            actionTitles: actionTitles
        )

        onSaveComplete()
        dismiss()
    }
}