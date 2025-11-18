//
//  FlowAnswerCollector.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

struct FlowAnswerCollector {
    /// Builds typed AttributeValue answers from raw string and choice answers for a node.
    static func buildAnswers(
        for node: FlowNode,
        textAnswers: [String: String],
        choiceAnswers: [String: String]
    ) -> Result<[String: AttributeValue], FlowValidationError> {

        var result: [String: AttributeValue] = [:]

        for q in node.questions {
            switch q.inputKind {
            case .text:
                let text = textAnswers[q.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if text.isEmpty {
                    return .failure(.missingAnswer(question: q))
                }
                result[q.id] = .text(text)

            case .number:
                let raw = textAnswers[q.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                guard !raw.isEmpty else {
                    return .failure(.missingAnswer(question: q))
                }
                guard let d = Double(raw) else {
                    return .failure(.invalidNumber(question: q))
                }
                result[q.id] = .number(d)

            case .boolean:
                // For now we do not render booleans yet, treat as missing.
                // You can extend later with a toggle UI.
                let raw = textAnswers[q.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if raw.lowercased() == "yes" || raw.lowercased() == "true" {
                    result[q.id] = .boolean(true)
                } else if raw.lowercased() == "no" || raw.lowercased() == "false" {
                    result[q.id] = .boolean(false)
                } else {
                    return .failure(.missingAnswer(question: q))
                }

            case .choice:
                guard let value = choiceAnswers[q.id], !value.isEmpty else {
                    return .failure(.missingAnswer(question: q))
                }
                result[q.id] = .choice(value)
            }
        }

        return .success(result)
    }
}
