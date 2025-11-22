//
//  CategoryType.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 22/11/2025.
//

import Foundation

/// Represents the *kind* of a Category.
/// Each case holds its own data structure
/// defining what fields this category contains.
enum CategoryType: Hashable {
    
    case choice(ChoiceData)
    case numberInputs(NumberInputsData)
    case textInputs(TextInputsData)
    case timeInput(TimeInputData)
    
    // In the future you can add:
    // case booleanInputs(BooleanInputsData)
    // case ratingInputs(RatingInputsData)
    // case dateInput(DateInputData)
}

// MARK: - Choice

struct ChoiceData: Hashable {
    var choices: [Choice]
}

/// One option inside a choice category.
/// Each choice can branch to multiple subcategories.
struct Choice: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var isOn: Bool
    var subcategories: [Category]   // children nodes
}

// MARK: - Number Inputs

struct NumberInputsData: Hashable {
    var inputs: [NumberInput]
}

struct NumberInput: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var inValue: Int?
}

// MARK: - Text Inputs

struct TextInputsData: Hashable {
    var inputs: [TextInput]
}

struct TextInput: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var inValue: String?
}

// MARK: - Time Input

struct TimeInputData: Hashable {
    var name: String
    var inValue: Date?
}
