//
//  CategoryView.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 29/11/2025.
//

import Foundation
import SwiftUI

// ---------------------------------
// Attribute representation item
// ---------------------------------
struct CategoryAttributeItem: Identifiable, Hashable {
    let id = UUID()
    let label: String
}

struct CategoryAttributePillView: View {
    let item: CategoryAttributeItem

    var body: some View {
        Text(item.label)
            .font(.caption2)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

// ---------------------------------
// Category card
// ---------------------------------
struct CategoryView: View {

    // The underlying category
    let category: Category

    // Local editable state, derived from category
    @State private var categoryName: String
    @State private var categoryType: CategoryType
    @State private var attributeItems: [CategoryAttributeItem]
    @State private var hasChildren: Bool

    init(category: Category) {
        self.category = category

        _categoryName = State(initialValue: category.name)
        _categoryType = State(initialValue: category.type)
        _attributeItems = State(initialValue: CategoryView.makeAttributeItems(from: category.type))
        _hasChildren = State(initialValue: CategoryView.inferHasChildren(from: category))
    }

    var body: some View {
        // Card size based on screen width
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth * 0.9
        let cardHeight = cardWidth * 0.4

        HStack {
            Spacer()

            HStack(spacing: 12) {

                // LEFT: 30% width, name + type
                VStack(alignment: .leading, spacing: 4) {
                    Text(categoryName)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Text(typeTitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .frame(width: cardWidth * 0.3, alignment: .leading)

                // MIDDLE: attributes row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(attributeItems) { item in
                            CategoryAttributePillView(item: item)
                        }
                    }
                }

                // RIGHT: state LED (children or not)
                Circle()
                    .fill(hasChildren ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
            }
            .padding()
            .frame(width: cardWidth, height: cardHeight, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 4)
            )

            Spacer()
        }
        .frame(height: cardHeight)
    }

    // MARK: - Helpers

    private var typeTitle: String {
        switch categoryType {
        case .choice:        return "Choice"
        case .numberInputs:  return "Number Inputs"
        case .textInputs:    return "Text Inputs"
        case .timeInput:     return "Time Input"
        }
    }

    private static func makeAttributeItems(from type: CategoryType) -> [CategoryAttributeItem] {
        switch type {
        case .choice(let data):
            return data.choices.map { CategoryAttributeItem(label: $0.name) }

        case .numberInputs(let data):
            return data.inputs.map { CategoryAttributeItem(label: $0.name) }

        case .textInputs(let data):
            return data.inputs.map { CategoryAttributeItem(label: $0.name) }

        case .timeInput(let data):
            return [CategoryAttributeItem(label: data.name)]
        }
    }

    /// Note: you said subcategories will not be empty only if `hasChildren == true`.
    /// Here we infer `hasChildren` from both subcategories and choice flags.
    private static func inferHasChildren(from category: Category) -> Bool {
        if !category.subcategories.isEmpty {
            return true
        }
        if case let .choice(choiceData) = category.type {
            return choiceData.choices.contains { $0.hasChildren }
        }
        return false
    }
}

// ---------------------------------
// Preview
// ---------------------------------
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCategory = Category(
            name: "Exercise",
            type: .choice(
                ChoiceData(choices: [
                    Choice(name: "Morning", isOn: true, hasChildren: false),
                    Choice(name: "Evening", isOn: false, hasChildren: true)
                ])
            ),
            subcategories: []    // could add subcategories here if you want
        )

        CategoryView(category: sampleCategory)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}
