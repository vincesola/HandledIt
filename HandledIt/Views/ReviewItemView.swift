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
        _actionCompleted = State(initialValue: Array(repeating: false, count: seed.actionTitles.count))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                eventDetailsCard
                appliesToCard
                actionsCard
                notesCard
                sourceCard
            }
            .padding(20)
        }
        .background(Color.handledBackground)
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 10) {
                Button(action: save) {
                    Text("Add to Timeline")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .tint(.handledPrimary)

                Button(action: {}) {
                    Text("Add to Calendar — Coming Later")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.bordered)
                .disabled(true)

                Button(action: ignore) {
                    Text("Ignore")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.handledTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.handledCard)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.handledBorder, lineWidth: 1)
                )
            }
            .padding(20)
            .background(.thinMaterial)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Review details")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.handledTextPrimary)

            Text("Edit anything before saving.")
                .font(.subheadline)
                .foregroundColor(.handledTextSecondary)
        }
    }

    private var eventDetailsCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Event details")
                    .font(.headline)

                labeledTextField(label: "Title", text: $title, placeholder: "Event title")
                labeledDatePicker(label: "Date", selection: $eventDate, displayedComponents: .date)
                Toggle("Include time", isOn: $includeTime)

                if includeTime {
                    DatePicker("Time", selection: $eventTime, displayedComponents: .hourAndMinute)
                }

                labeledTextField(label: "Location", text: $location, placeholder: "Optional location")
            }
        }
    }

    private var appliesToCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("Applies to")
                    .font(.headline)

                labeledPicker(label: "Child", selection: $selectedChild, items: store.childProfiles)
            }
        }
    }

    private var actionsCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Action items")
                        .font(.headline)

                    Spacer()

                    Button("Add item") {
                        actionTitles.append("")
                        actionCompleted.append(false)
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.handledPrimary)
                }

                if actionTitles.isEmpty {
                    Text("No actions suggested yet.")
                        .font(.subheadline)
                        .foregroundColor(.handledTextSecondary)
                } else {
                    ForEach(actionTitles.indices, id: \.self) { index in
                        HStack(spacing: 12) {
                            Button(action: {
                                actionCompleted[index].toggle()
                            }) {
                                Image(systemName: actionCompleted[index] ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundColor(actionCompleted[index] ? .handledPrimary : .handledTextSecondary)
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
        }
    }

    private var notesCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("Notes")
                    .font(.headline)

                labeledTextEditor(label: "Notes", text: $notes)
            }
        }
    }

    private var sourceCard: some View {
        HandledCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Source preview")
                    .font(.headline)

                Text(item.title)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.handledTextPrimary)

                Text(item.content)
                    .font(.subheadline)
                    .foregroundColor(.handledTextSecondary)
            }
        }
    }

    private func labeledTextField(
        label: String,
        text: Binding<String>,
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
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
                .font(.headline)
                .foregroundColor(.handledTextSecondary)

            DatePicker("", selection: selection, displayedComponents: displayedComponents)
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
                .font(.headline)
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
                .font(.headline)
                .foregroundColor(.handledTextSecondary)

            TextEditor(text: text)
                .frame(minHeight: 110)
                .padding(8)
                .background(Color.handledBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.handledBorder, lineWidth: 1)
                )
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
