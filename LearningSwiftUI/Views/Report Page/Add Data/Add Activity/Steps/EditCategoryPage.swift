import SwiftUI

struct EditCategoryPage: View {

    @Binding var category: Category
    var onDone: () -> Void

    // Local editable copy of the type
    @State private var editingAttributeID: UUID? = nil
    @State private var tempAttributeName: String = ""

    // NEW: children editor state
    @State private var showChildrenEditor = false
    @State private var editingChildrenChoiceID: UUID? = nil
    @State private var tempChildren: [Category] = []

    var body: some View {
        VStack(spacing: 16) {

            // MAIN TITLE
            Text("Category: \(category.name)")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 24)

            // SECONDARY TITLE (type)
            Text("\(typeLabel) type")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // ATTRIBUTES LIST
            ScrollView {
                VStack(spacing: 12) {
                    if attributeItems.isEmpty {
                        Text("No attributes yet")
                            .foregroundColor(.secondary)
                            .padding(.top, 16)
                    } else {
                        ForEach(attributeItems) { item in
                            if editingAttributeID == item.id {
                                // Edit mode
                                TextField("", text: $tempAttributeName, onCommit: {
                                    commitAttributeRename(id: item.id, newName: tempAttributeName)
                                })
                                .textFieldStyle(.roundedBorder)
                                .padding()
                            } else {
                                // Normal card + optional "children" button for choices
                                HStack(spacing: 8) {
                                    Button {
                                        startEditingAttribute(item)
                                    } label: {
                                        AttributeCardView(title: item.label)
                                    }
                                    .buttonStyle(.plain)

                                    if isChoiceType {
                                        Button {
                                            openChildrenEditor(for: item.id)
                                        } label: {
                                            Image(systemName: "arrow.turn.down.right")
                                                .font(.system(size: 16, weight: .medium))
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            // ADD ATTRIBUTE BUTTON
            AddAttributeButton {
                addAttribute()
            }
            .padding(.horizontal, 24)

            Spacer(minLength: 16)

            // COMPLETE CATEGORY BUTTON
            CompleteCategoryButton {
                onDone()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        // CHILDREN EDITOR SHEET
        .sheet(isPresented: $showChildrenEditor, onDismiss: {
            applyChildrenChanges()
        }) {
            if let name = currentChildrenChoiceName() {
                EditChoiceChildrenPage(
                    choiceName: name,
                    subcategories: $tempChildren
                )
            } else {
                Text("No choice selected")
            }
        }
    }

    // MARK: - Labels and derived items

    private var typeLabel: String {
        switch category.type {
        case .choice:        return "Choice"
        case .numberInputs:  return "Number"
        case .textInputs:    return "Text"
        case .timeInput:     return "Time"
        }
    }

    private var isChoiceType: Bool {
        if case .choice = category.type { return true }
        return false
    }

    // A simple internal representation of an attribute for display
    private struct AttributeItem: Identifiable {
        let id: UUID
        let label: String
    }

    // Flatten CategoryType into a list of labels to show as cards
    private var attributeItems: [AttributeItem] {
        switch category.type {
        case .choice(let data):
            return data.choices.map { AttributeItem(id: $0.id, label: $0.name) }

        case .numberInputs(let data):
            return data.inputs.map { AttributeItem(id: $0.id, label: $0.name) }

        case .textInputs(let data):
            return data.inputs.map { AttributeItem(id: $0.id, label: $0.name) }

        case .timeInput:
            return []
        }
    }

    // MARK: - Mutations

    private func addAttribute() {
        switch category.type {

        case .choice(var data):
            let newChoice = Choice(name: "New choice", isOn: false, hasChildren: false)
            data.choices.append(newChoice)
            category.type = .choice(data)

            editingAttributeID = newChoice.id
            tempAttributeName = newChoice.name

        case .numberInputs(var data):
            let newInput = NumberInput(name: "New number", inValue: nil)
            data.inputs.append(newInput)
            category.type = .numberInputs(data)

            editingAttributeID = newInput.id
            tempAttributeName = newInput.name

        case .textInputs(var data):
            let newInput = TextInput(name: "New text", inValue: nil)
            data.inputs.append(newInput)
            category.type = .textInputs(data)

            editingAttributeID = newInput.id
            tempAttributeName = newInput.name

        case .timeInput(var data):
            if data.name.isEmpty {
                data.name = "Time"
            }
            category.type = .timeInput(data)
        }
    }

    private func startEditingAttribute(_ item: AttributeItem) {
        editingAttributeID = item.id
        tempAttributeName = item.label
    }

    private func commitAttributeRename(id: UUID, newName: String) {
        switch category.type {

        case .choice(var data):
            if let i = data.choices.firstIndex(where: { $0.id == id }) {
                data.choices[i].name = newName
            }
            category.type = .choice(data)

        case .numberInputs(var data):
            if let i = data.inputs.firstIndex(where: { $0.id == id }) {
                data.inputs[i].name = newName
            }
            category.type = .numberInputs(data)

        case .textInputs(var data):
            if let i = data.inputs.firstIndex(where: { $0.id == id }) {
                data.inputs[i].name = newName
            }
            category.type = .textInputs(data)

        case .timeInput:
            break
        }

        editingAttributeID = nil
        tempAttributeName = ""
    }

    // MARK: - Children editing

    private func openChildrenEditor(for id: UUID) {
        guard case .choice(let data) = category.type,
              let choice = data.choices.first(where: { $0.id == id }) else {
            return
        }
        editingChildrenChoiceID = id
        tempChildren = choice.subcategories
        showChildrenEditor = true
    }

    private func currentChildrenChoiceName() -> String? {
        guard let id = editingChildrenChoiceID,
              case .choice(let data) = category.type,
              let choice = data.choices.first(where: { $0.id == id }) else {
            return nil
        }
        return choice.name
    }

    private func applyChildrenChanges() {
        guard let id = editingChildrenChoiceID,
              case .choice(var data) = category.type else {
            return
        }
        if let idx = data.choices.firstIndex(where: { $0.id == id }) {
            data.choices[idx].subcategories = tempChildren
            data.choices[idx].hasChildren = !tempChildren.isEmpty
            category.type = .choice(data)
        }
    }
}
