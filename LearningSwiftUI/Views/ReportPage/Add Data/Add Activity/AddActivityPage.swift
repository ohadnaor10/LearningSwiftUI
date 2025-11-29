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
        case editCategory
    }

    @State private var step: FlowStep = .name

    // DRAFT DATA
    @State private var activityName: String = ""
    @State private var categories: [Category] = []
    @State private var currentEditingIndex: Int? = nil

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            switch step {

            // STEP 1 – NAME
            case .name:
                AddActivityNameStep(
                    activityName: $activityName,
                    onNext: {
                        step = .categories
                    }
                )

            // STEP 2 – CATEGORIES
            case .categories:
                VStack(spacing: 0) {

                    // Top bar
                    AddCategoryTopBar(activityName: activityName)

                    // Body: list of CategoryView cards
                    ScrollView {
                        VStack(spacing: 16) {
                            if categories.isEmpty {
                                Text("No categories yet")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 24)
                            } else {
                                ForEach(categories) { category in
                                    CategoryView(category: category)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }

                    // Add Category button
                    AddCategoryButton {
                        // TODO: create a new Category with default type and go to editCategory step
                        // Example placeholder:
                        let newCategory = Category(
                            name: "New Category",
                            type: .textInputs(TextInputsData(inputs: []))
                        )
                        categories.append(newCategory)
                        currentEditingIndex = categories.count - 1
                        step = .editCategory
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    // Complete Activity button
                    CompleteActivityButton {
                        // TODO: build Activity and add to global store
                        // For now, just dismiss
                        dismiss()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }

            // STEP 3 – EDIT CATEGORY
            case .editCategory:
                Text("Edit Category Step (to be created)")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
