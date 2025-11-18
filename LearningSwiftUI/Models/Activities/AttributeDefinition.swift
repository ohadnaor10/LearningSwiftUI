//
//  AttributeDefinition.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

struct AttributeDefinition: Identifiable, Hashable {
    /// Stable id inside the activity, like "ml" or "benchSets"
    let id: String
    /// Human readable label
    let displayName: String
    /// Basic type of the value
    let kind: AttributeKind
    /// For choice attributes only
    let choices: [String]?

    init(id: String,
         displayName: String,
         kind: AttributeKind,
         choices: [String]? = nil) {
        self.id = id
        self.displayName = displayName
        self.kind = kind
        self.choices = choices
    }
}
