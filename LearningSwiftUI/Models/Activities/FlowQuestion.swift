//
//  FlowQuestion.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

struct FlowQuestion: Identifiable, Hashable {
    /// Unique inside the flow
    let id: String
    /// Prompt text for the user
    let prompt: String
    /// Input type
    let inputKind: AttributeKind
    /// Choices for choice questions
    let choices: [String]?
    /// Which attribute this question fills (schema mapping). Optional for logic-only questions.
    let boundAttributeId: String?

    init(id: String,
         prompt: String,
         inputKind: AttributeKind,
         choices: [String]? = nil,
         boundAttributeId: String? = nil) {
        self.id = id
        self.prompt = prompt
        self.inputKind = inputKind
        self.choices = choices
        self.boundAttributeId = boundAttributeId
    }
}
