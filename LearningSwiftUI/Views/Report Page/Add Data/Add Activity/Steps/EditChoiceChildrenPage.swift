import SwiftUI

struct EditChoiceChildrenPage: View {

    let choiceName: String
    @Binding var subcategories: [Category]

    @Environment(\.dismiss) private var dismiss

    private enum Step {
        case categories          // list of child categories
        case pickCategoryType    // choose type for newly added child
        case editCategory        // edit the chosen child category
    }

    @State private var step: Step = .categories
    @State private var currentEditingIndex: Int? = nil

    var body: some View {
        switch step {

        // -----------------------------------
        // STEP – CATEGORIES (for this choice)
        // -----------------------------------
        case .categories:
            VStack(spacing: 0) {

                // Top bar, reuse your existing one
                AddCategoryTopBar(activityName: choiceName)

                // Body: list of CategoryView cards
                ScrollView {
                    VStack(spacing: 16) {
                        if subcategories.isEmpty {
                            Text("No categories yet")
                                .foregroundColor(.secondary)
                                .padding(.top, 24)
                        } else {
                            ForEach(Array(subcategories.enumerated()), id: \.element.id) { index, category in
                                Button {
                                    currentEditingIndex = index
                                    step = .editCategory
                                } label: {
                                    CategoryView(category: category)
                                }
                                .buttonStyle(.plain)
                            }

                        }
                    }
                    .padding(.vertical, 16)
                }

                // Add Category button
                AddCategoryButton {
                    let newCategory = Category(
                        name: "",
                        type: .textInputs(TextInputsData(inputs: [])) // temporary
                    )

                    subcategories.append(newCategory)
                    currentEditingIndex = subcategories.count - 1
                    step = .pickCategoryType
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                // Done editing children
                CompleteActivityButton(title: "Complete Subcategories") {
                    dismiss()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }

        // -----------------------------------
        // PICK TYPE FOR NEW / EDITED CHILD
        // -----------------------------------
        case .pickCategoryType:
            if let index = currentEditingIndex {
                PickCategoryTypePage(
                    onPick: { selectedType in
                        subcategories[index].type = selectedType
                        step = .editCategory
                    },
                    onCancel: {
                        // same behavior as your main flow:
                        // you can optionally remove the placeholder category:
                        // subcategories.remove(at: index)
                        step = .categories
                    }
                )
            } else {
                VStack {
                    Text("No category selected")
                    Button("Back") {
                        step = .categories
                    }
                }
            }

        // -----------------------------------
        // EDIT CHILD CATEGORY
        // -----------------------------------
        case .editCategory:
            if let index = currentEditingIndex {
                EditCategoryPage(
                    category: $subcategories[index]
                ) {
                    step = .categories
                }
            } else {
                VStack {
                    Text("No category selected")
                    Button("Back") {
                        step = .categories
                    }
                }
            }
        }
    }
}
