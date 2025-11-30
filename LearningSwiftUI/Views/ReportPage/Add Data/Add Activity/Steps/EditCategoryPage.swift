import SwiftUI

struct EditCategoryPage: View {

    @Binding var category: Category
    var onDone: () -> Void

    // Local editable copy of the type
    @State private var localType: CategoryType

    init(category: Binding<Category>, onDone: @escaping () -> Void) {
        self._category = category
        self.onDone = onDone
        _localType = State(initialValue: category.wrappedValue.type)
    }

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
                            AttributeCardView(title: item.label)
                        }
                    }
                }
                .padding(.horizontal, 24)
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
                category.type = localType
                onDone()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Labels and derived items

    private var typeLabel: String {
        switch localType {
        case .choice:        return "Choice"
        case .numberInputs:  return "Number"
        case .textInputs:    return "Text"
        case .timeInput:     return "Time"
        }
    }

    // A simple internal representation of an attribute for display
    private struct AttributeItem: Identifiable {
        let id = UUID()
        let label: String
    }

    // Flatten CategoryType into a list of labels to show as cards
    private var attributeItems: [AttributeItem] {
        switch localType {
        case .choice(let data):
            return data.choices.map { AttributeItem(label: $0.name) }

        case .numberInputs(let data):
            return data.inputs.map { AttributeItem(label: $0.name) }

        case .textInputs(let data):
            return data.inputs.map { AttributeItem(label: $0.name) }

        case .timeInput(let data):
            return [AttributeItem(label: data.name)]
        }
    }

    // MARK: - Mutations

    private func addAttribute() {
        switch localType {

        case .choice(var data):
            let newChoice = Choice(name: "New choice", isOn: false, hasChildren: false)
            data.choices.append(newChoice)
            localType = .choice(data)

        case .numberInputs(var data):
            let newInput = NumberInput(name: "New number", inValue: nil)
            data.inputs.append(newInput)
            localType = .numberInputs(data)

        case .textInputs(var data):
            let newInput = TextInput(name: "New text", inValue: nil)
            data.inputs.append(newInput)
            localType = .textInputs(data)

        case .timeInput(var data):
            // For time input, if there is no name yet, set one
            if data.name.isEmpty {
                data.name = "Time"
            } else {
                // In this model there is only one time input, so we do nothing extra
            }
            localType = .timeInput(data)
        }
    }
}
