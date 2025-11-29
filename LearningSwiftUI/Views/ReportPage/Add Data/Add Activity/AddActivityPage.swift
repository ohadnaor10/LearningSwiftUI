//
//  ReportCoordinator.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 25/11/2025.
//
import SwiftUI

struct AddActivityPage: View {

    // ---------------------------------
    // STEP ENUM
    // ---------------------------------
    enum FlowStep {
        case name
        case categories
        case editCategory
    }

    @State private var step: FlowStep = .name

    // ---------------------------------
    // DRAFT DATA (for internal use)
    // ---------------------------------
    @State private var activityName: String = ""
    @State private var categories: [Category] = []
    @State private var currentEditingIndex: Int? = nil

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            switch step {

            // STEP 1: NAME
            case .name:
                AddActivityNameStep(
                    activityName: $activityName,
                    onNext: {
                        // Move to categories step
                        step = .categories
                    }
                )

            // STEP 2: CATEGORIES (UI not built yet)
            case .categories:
                Text("Categories Step (to be created)")

            // STEP 3: EDIT CATEGORY (UI not built yet)
            case .editCategory:
                Text("Edit Category Step (to be created)")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
