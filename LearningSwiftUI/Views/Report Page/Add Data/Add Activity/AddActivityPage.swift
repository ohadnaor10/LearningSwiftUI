//
//  ReportCoordinator.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 25/11/2025.
//
import SwiftUI



struct AddActivityPage: View {
    

    enum FlowStep {
        case name
        case categories
        case pickCategoryType
        case editCategory
    }

    @State private var step: FlowStep = .name

    // DRAFT DATA
    @State private var currentlyCreatedActivity = Activity(name: "", categories: [])
//    @State private var activityName: String = ""
//    @State private var categories: [Category] = []
    @State private var currentEditingIndex: Int? = nil

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userData: UserData
    
    @Binding var group: ActivityGroup     // ← NEW    

    var body: some View {
        VStack {
            switch step {

            // STEP 1 – NAME
            case .name:
                AddActivityNameStep(
                    activityName: $currentlyCreatedActivity.name,
                    onNext: {
                        step = .categories
                    }
                )


            // STEP 2 – CATEGORIES
            case .categories:
                VStack(spacing: 0) {

                    // Top bar
                    AddCategoryTopBar(activityName: currentlyCreatedActivity.name)

                    // Body: list of CategoryView cards
                    ScrollView {
                        VStack(spacing: 16) {
                            if currentlyCreatedActivity.categories.isEmpty {
                                Text("No categories yet")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 24)
                            } else {
                                ForEach(currentlyCreatedActivity.categories) { category in
                                    CategoryView(category: category)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }

                    // Add Category button
                    AddCategoryButton {
                        // 1. Create a blank category with a placeholder type
                        let newCategory = Category(
                            name: "",
                            type: .textInputs(TextInputsData(inputs: [])) // temporary, will be overwritten
                        )

                        // 2. Append it
                        currentlyCreatedActivity.categories.append(newCategory)

                        // 3. Track which one we're editing
                        currentEditingIndex = currentlyCreatedActivity.categories.count - 1

                        // 4. Move to pick-category-type step
                        step = .pickCategoryType
                    }

                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    // Complete Activity button
                    CompleteActivityButton {
                        userData.activities.append(currentlyCreatedActivity) // add activity globally
                        group.activities
                            .append(currentlyCreatedActivity) //add to the group
                        dismiss()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            case .pickCategoryType:
                PickCategoryTypePage(
                    onPick: { selectedType in
                        currentlyCreatedActivity.categories[currentEditingIndex!].type = selectedType
                        step = .editCategory
                    },
                    onCancel: {
                        // rollback if needed
                        step = .categories
                    }
                )

            
            // STEP 4 – EDIT CATEGORY
            case .editCategory:
                if let index = currentEditingIndex {
                    EditCategoryPage(
                        category: $currentlyCreatedActivity.categories[index],
                        onDone: {
                            step = .categories
                        }
                    )
                } else {
                    // Fallback if somehow no index
                    Text("No category selected")
                }

            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
