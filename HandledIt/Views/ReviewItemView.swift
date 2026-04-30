import SwiftUI

struct ReviewItemView: View {
    let item: InboxItem
    let seed: HandledItStore.ReviewSeed

    @EnvironmentObject private var store: HandledItStore
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var eventDate: Date
    @State private var includeTime: Bool
    @State private var eventTime: Date
    @State private var location: String
    @State private var selectedChild: ChildProfile
    @State private var notes: String
    @State private var actionTitles: [String]
    @State private var actionCompleted: [Bool]

    init(item: InboxItem, seed: HandledItStore.ReviewSeed) {
        self.item = item
        self.seed = seed
        _title = State(initialValue: seed.title)
        _eventDate = State(initialValue: seed.date)
        _includeTime = State(initialValue: seed.time != nil)
        _eventTime = State(initialValue: seed.time ?? seed.date)
        _location = State(initialValue: seed.location)
        _selectedChild = State(initialValue: seed.child)
        _notes = State(initialValue: seed.notes)
        _actionTitles = State(initialValue: seed.actionTitles)
        _actionCompleted = State(
            initialValue: Array(repeating: false, count: seed.actionTitles.count)
        )
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
        .background(Color.handledBackground)
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Ignore") {
                    ignore()
                }
                .foregroundColor(.red)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 10) {
                Button(action: save) {
                    Text("Add to Timeline")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)

                Button(action: {}) {
                    Text("Add to Calendar (coming later)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }
            .padding(20)
            .background(.thinMaterial)
        }
    }

    private var sourceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Source")
                .font(.headline)

            Text(item.title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.handledTextPrimary)

            Text(item.content)
                .font(.subheadline)
                .foregroundColor(.handledTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Suggested details")
                .font(.headline)

            Group {
                labeledTextField(
                    label: "Title",
                    text: $title,
                    placeholder: "Event title"
                )

                labeledDatePicker(
                    label: "Date",
                    selection: $eventDate,
                    displayedComponents: .date
                )

                Toggle("Include time", isOn: $includeTime)

                if includeTime {
                    DatePicker(
                        "Time",
                        selection: $eventTime,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }

                labeledTextField(
                    label: "Location",
                    text: $location,
                    placeholder: "Optional location"
                )

                labeledPicker(
                    label: "Child",
                    selection: $selectedChild,
                    items: store.childProfiles
                )

                labeledTextEditor(
                    label: "Notes",
                    text: $notes
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var actionsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Action items")
                    .font(.headline)

                Spacer()

                Button("Add") {
                    actionTitles.append("")
                    actionCompleted.append(false)
                }
            }

            if actionTitles.isEmpty {
                Text("No actions suggested yet.")
                    .font(.subheadline)
                    .foregroundColor(.handledTextSecondary)
            } else {
                ForEach(actionTitles.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Button(
                            action: {
                                actionCompleted[index].toggle()
                            }
                        ) {
                            Image(
                                systemName: actionCompleted[index]
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                            .font(.title3)
                            .foregroundColor(
                                actionCompleted[index]
                                    ? .handledPrimary
                                    : .handledTextSecondary
                            )
                        }
                        .buttonStyle(.plain)

                        TextField("Action item", text: binding(for: index))
                            .textFieldStyle(.roundedBorder)

                        Button {
                            actionTitles.remove(at: index)
                            actionCompleted.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.handledTextSecondary)
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
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private func labeledTextField(
        label: String,
        text: Binding<String>,
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(.handledTextSecondary)

            TextField(placeholder, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    private func labeledDatePicker(
        label: String,
        selection: Binding<Date>,
        displayedComponents: DatePicker.Components
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(.handledTextSecondary)

            DatePicker(
                "",
                selection: selection,
                displayedComponents: displayedComponents
            )
            .labelsHidden()
        }
    }

    private func labeledPicker(
        label: String,
        selection: Binding<ChildProfile>,
        items: [ChildProfile]
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(.handledTextSecondary)

            Picker("Child", selection: selection) {
                ForEach(items) { child in
                    Text(child.name).tag(child)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func labeledTextEditor(
        label: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(.handledTextSecondary)

            TextEditor(text: text)
                .frame(minHeight: 110)
                .padding(8)
                .background(Color.handledBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private func binding(for index: Int) -> Binding<String> {
        Binding(
            get: { actionTitles[index] },
            set: { actionTitles[index] = $0 }
        )
    }

    private func save() {
        store.addReviewedEvent(
            from: item,
            title: title,
            date: eventDate,
            time: includeTime ? eventTime : nil,
            location: location,
            notes: notes,
            child: selectedChild,
            actionTitles: actionTitles
        )

        dismiss()
    }

    private func ignore() {
        store.ignoreInboxItem(item)
        dismiss()
    }
}
