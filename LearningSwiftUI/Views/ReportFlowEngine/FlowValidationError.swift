//
//  FlowValidationError.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

enum FlowValidationError: LocalizedError {
    case missingAnswer(question: FlowQuestion)
    case invalidNumber(question: FlowQuestion)

    var errorDescription: String? {
        switch self {
        case .missingAnswer(let q):
            return "Please answer: \(q.prompt)"
        case .invalidNumber(let q):
            return "Enter a valid number for: \(q.prompt)"
        }
    }
}
