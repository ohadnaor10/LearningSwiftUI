//
//  FlowRunner.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation
import Combine

final class FlowRunner: ObservableObject {
    let activityType: ActivityType

    @Published private(set) var currentNode: FlowNode?
    @Published private(set) var finishedInstance: ActivityInstance?

    private var currentNodeId: String?
    private var collectedValues: [String: AttributeValue] = [:]

    init(activityType: ActivityType) {
        self.activityType = activityType
    }

    func start() {
        currentNodeId = activityType.rootNodeId
        currentNode = activityType.nodes[currentNodeId ?? ""]
        finishedInstance = nil
        collectedValues = [:]
    }

    /// Called by the UI when the user taps "Next" on a node.
    func handleNext(answersByQuestionId: [String: AttributeValue]) {
        guard let node = currentNode else { return }

        // Store mapped attributes
        for q in node.questions {
            guard let attrId = q.boundAttributeId else { continue }
            if let value = answersByQuestionId[q.id] {
                collectedValues[attrId] = value
            }
        }

        // Decide where to go next
        switch node.routing {
        case .end:
            finish()

        case .linear(let nextId):
            goToNode(id: nextId)

        case .branching(let choiceMap):
            // Find the choice question and its selected value
            if let choiceQuestion = node.questions.first(where: { $0.inputKind == .choice }),
               let value = answersByQuestionId[choiceQuestion.id],
               case let .choice(selected) = value,
               let nextId = choiceMap[selected] {
                goToNode(id: nextId)
            } else {
                // If mapping fails, just finish for now
                finish()
            }
        }
    }

    private func goToNode(id: String) {
        currentNodeId = id
        currentNode = activityType.nodes[id]
    }

    private func finish() {
        let instance = ActivityInstance(
            id: UUID(),
            activityTypeId: activityType.id,
            timestamp: Date(),
            values: collectedValues
        )
        finishedInstance = instance
        currentNode = nil
    }
}
